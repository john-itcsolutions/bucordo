#!/usr/bin/perl -w

use strict;
use warnings;
use lib 't';
use Test::More;
use bucordoTesting;
use Data::Dumper;


my $bct = bucordoTesting->new({location => 'postgres'})
    or BAIL_OUT 'Creation of bucordoTesting object failed';

END { $bct->stop_bucordo if $bct }

my $dbh = $bct->empty_cluster('A');
END { $dbh->disconnect if $dbh }

# Skip the tests if we can't mock the serialization failure.
plan skip_all => "Cannot mock serialization failure on Postgres $dbh->{pg_server_version}"
    if $dbh->{pg_server_version} < 80400;

# We are a go!
plan tests => 45;
$dbh->disconnect;
$dbh = undef;

ok my $dbhA = $bct->repopulate_cluster('A'), 'Populate cluster A';
ok my $dbhB = $bct->repopulate_cluster('B'), 'Populate cluster B';
ok my $dbhX = $bct->setup_bucordo('A'), 'Set up bucordo';

END { $_->disconnect for grep { $_ } $dbhA, $dbhB, $dbhX }

# Teach bucordo about the databases.
for my $db (qw(A B)) {
    my ($user, $port, $host) = $bct->add_db_args($db);
    like $bct->ctl(
        "bucordo add db $db dbname=bucordo_test user=$user port=$port host=$host"
    ), qr/Added database "$db"/, qq{Add database "$db" to bucordo};
}

# Let's just deal with table bucordo_test1 and bucordo_test2.
for my $num (1, 2) {
    like $bct->ctl("bucordo add table bucordo_test$num db=A relgroup=myrels"),
        qr/Added the following tables/, "Add table bucordo_test$num";
}

# Create a new dbgroup going from A to B
like $bct->ctl('bucordo add dbgroup serial1 A:source B:target'),
    qr/Created dbgroup "serial1"/, 'Create relgroup serial1';

# Create a sync for this group.
like $bct->ctl('bucordo add sync serialtest1 relgroup=myrels dbs=serial1'),
    qr/Added sync "serialtest1"/, 'Create sync "serialtest1"';

# Set up a rule to mock a serialization failure on B.bucordo_test2.
ok $bct->mock_serialization_failure($dbhB, 'bucordo_test2'),
    'Mock serialization failure on bucordo_test2';
END {
    $bct->unmock_serialization_failure($dbhB, 'bucordo_test2')
        if $bct && $dbhB;
}

# Listen in on things.
ok $dbhX->do('LISTEN bucordo_syncdone_serialtest1'),
    'Listen for syncdone';
ok $dbhX->do('LISTEN bucordo_syncsleep_serialtest1'),
    'Listen for syncsleep';

# Start up bucordo.
ok $bct->restart_bucordo($dbhX), 'bucordo should start';

ok $bct->wait_for_notice($dbhX, 'bucordo_syncdone_serialtest1'),
    'The sync should finish';

# Should have no rows.
$bct->check_for_row([], [qw(A B)], undef, 'test[12]$');

# Make sure the sync was recorded.
ok my $runs = $dbhX->selectall_arrayref(
    'SELECT * FROM syncrun ORDER BY started',
    { Slice => {} },
), 'Get list of syncruns';
is(scalar @{ $runs }, 1, 'Should have one syncrun');
ok $runs->[0]{ended}, 'It should have an "ended" value';
ok $runs->[0]{lastempty}, 'It should be marked "last empty"';
like $runs->[0]{status}, qr/^No delta rows found/,
    'Its status should be "No delta rows found"';

# Let's add some data into A.bucordo_test1.
$dbhX->commit;
ok $dbhA->do(q{INSERT INTO bucordo_test1 (id, data1) VALUES (1, 'foo')}),
    'Insert a row into test1';
$dbhA->commit;

ok $bct->wait_for_notice($dbhX, 'bucordo_syncdone_serialtest1'),
    'Second sync should finish';

# The row should be in both databases.
is_deeply $dbhB->selectall_arrayref(
    'SELECT id, data1 FROM bucordo_test1'
), [[1, 'foo']], 'Should have the test1 row in B';

# Should have two syncrun records now.
ok $runs = $dbhX->selectall_arrayref(
    'SELECT * FROM syncrun ORDER BY started',
    { Slice => {} },
), 'Get list of syncruns';
is(scalar @{ $runs }, 2, 'Should have two syncruns');
ok $runs->[1]{ended}, 'New run should have an "ended" value';
ok $runs->[1]{lastgood}, 'It should be marked "last good"';
like $runs->[1]{status}, qr/^Complete/, 'Its status should be "Complete"';

# Excellent. Now let's insert into test2.
$dbhX->commit;
ok $dbhA->do(q{INSERT INTO bucordo_test2 (id, data1) VALUES (2, 'foo')}),
    'Insert a row into test2';
$dbhA->commit;

ok $bct->wait_for_notice($dbhX, 'bucordo_syncsleep_serialtest1'),
    'Should get a syncsleep message';

ok $bct->wait_for_notice($dbhX, 'bucordo_syncdone_serialtest1'),
    'Then the third sync should finish';

is_deeply $dbhB->selectall_arrayref(
    'SELECT id, data1 FROM bucordo_test2'
), [[2, 'foo']], 'Should have the B test2 row despite serialization failure';

# Should have four syncrun records now.
ok $runs = $dbhX->selectall_arrayref(
    'SELECT * FROM syncrun ORDER BY started',
    { Slice => {} },
), 'Get list of syncruns';
is(scalar @{ $runs }, 4, 'Should have four syncruns');
ok $runs->[2]{ended}, 'Third run should have an "ended" value';
ok $runs->[2]{lastbad}, 'Third run should be marked "last bad"';
like $runs->[2]{status}, qr/^Failed/, 'Third run status should be "Bad"';

ok $runs->[3]{ended}, 'Fourth run should have an "ended" value';
ok $runs->[3]{lastgood}, 'Fourth run should be marked "last good"';
like $runs->[3]{status}, qr/^Complete/, 'Fourth run status should be "Complete"';
