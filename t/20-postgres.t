#!/usr/bin/env perl
# -*-mode:cperl; indent-tabs-mode: nil-*-

## Test using Postgres as a database target

use 5.008003;
use strict;
use warnings;
use Data::Dumper;
use lib 't','.';
use DBD::Pg;
use Test::More;
use MIME::Base64;
use File::Temp qw/ tempfile /;
use Cwd;

use vars qw/ $dbhX $dbhA $dbhB $dbhC $dbhD $dbhE $res $command $t $SQL %pkey %sth %sql $sth $count $val /;

use bucordoTesting;
my $bct = bucordoTesting->new({location => 'postgres'})
    or BAIL_OUT "Creation of bucordoTesting object failed\n";

## Some of the tests are called inside of bucordoTesting.pm
## e.g. $bct->check_for_row([[1]], [qw/ B C D/]);
## The above runs one test for each passed in database x the number of test tables
my $numtables = keys %tabletype;
my $numsequences = keys %sequences;
my $single_tests = 63;
my $check_for_row_1 = 1;
my $check_for_row_2 = 2;
my $check_for_row_3 = 3;
my $check_for_row_4 = 7;
my $check_sequences_same = 1;

## We have to set up the PGSERVICEFILE early on, so the proper
## environment variable is set for all processes from the beginning.
my ($service_fh, $service_temp_filename) = tempfile("bucordo_pgservice.tmp.XXXX", UNLINK => 0);
$ENV{PGSERVICEFILE} = getcwd . '/' . $service_temp_filename;

plan tests => $single_tests +
    ( $check_sequences_same * $numsequences ) + ## Simple sequence testing
    ( $check_for_row_1 * $numtables * 1 ) + ## D
    ( $check_for_row_2 * $numtables * 2 ) + ## A B
    ( $check_for_row_3 * $numtables * 3 ) + ## B C D
    ( $check_for_row_4 * $numtables * 4 ); ## A B C D

pass("*** Beginning postgres tests");

END {
    $bct and $bct->stop_bucordo();
    $dbhX and $dbhX->disconnect();
    $dbhA and $dbhA->disconnect();
    $dbhB and $dbhB->disconnect();
    $dbhC and $dbhC->disconnect();
    $dbhD and $dbhD->disconnect();
    $dbhE and $dbhE->disconnect();
}

## Get A, B, C, D, and E created, emptied out, and repopulated with sample data
$dbhA = $bct->repopulate_cluster('A');
$dbhB = $bct->repopulate_cluster('B');
$dbhC = $bct->repopulate_cluster('C');
$dbhD = $bct->repopulate_cluster('D');
$dbhE = $bct->repopulate_cluster('E');

## Create a bucordo database, and install bucordo into it
$dbhX = $bct->setup_bucordo('A');

## Teach bucordo about the first four databases
for my $name (qw/ A B C D A1 /) {
    $t = "Adding database from cluster $name works";
    my ($dbuser,$dbport,$dbhost) = $bct->add_db_args($name);
    $command = "bucordo add db $name dbname=bucordo_test user=$dbuser port=$dbport host=$dbhost status=active conn=sslmode=allow";
    $res = $bct->ctl($command);
    like ($res, qr/Added database "$name"/, $t);
}

## Teach bucordo about the fifth database using a service file
$t = "Adding database E via a service name works";
my ($dbuser,$dbport,$dbhost) = $bct->add_db_args('E');
print $service_fh "[dbE]\ndbname=bucordo_test\nuser=$dbuser\nport=$dbport\nhost=$dbhost\n";
close $service_fh;
$res = $bct->ctl("add db E service=dbE status=inactive");
like ($res, qr/Added database "E"/, $t);

## Put all pk tables into a relgroup
$t = q{Adding all PK tables on the master works};
$res = $bct->ctl(q{bucordo add tables '*bucordo*test*' '*bucordo*test*' db=A relgroup=allpk pkonly});
like ($res, qr/Created the relgroup named "allpk".*are now part of/s, $t);

## Add all sequences
$t = q{Adding all sequences to the main relgroup};
$res = $bct->ctl(q{bucordo add all sequences relgroup=allpk});
like ($res, qr/New sequences added/s, $t);

## Create a new dbgroup going from A to B and C and D and E
$t = q{Created a new dbgroup A -> B C D E};
$res = $bct->ctl('bucordo add dbgroup pg1 A:source B:target C:target D:target E:target');
like ($res, qr/Created dbgroup "pg1"/, $t);

## Create a new dbgroup going from A and B to C and D
$t = q{Created a new dbgroup (A <=> B ) -> C D};
$res = $bct->ctl('bucordo add dbgroup pg2 A:source B:source C D');
like ($res, qr/Created dbgroup "pg2"/, $t);

## Create a new dbgroup going from A and B and C to D
$t = q{Created a new dbgroup (A <=> B <=> C) -> D};
$res = $bct->ctl('bucordo add dbgroup pg3 A:source B:source C:source D');
like ($res, qr/Created dbgroup "pg3"/, $t);

## Create a new dbgroup going from A and B and C and D
$t = q{Created a new dbgroup (A <=> B <=> C <=> D)};
$res = $bct->ctl('bucordo add dbgroup pg4 A:source B:source C:source D:source');
like ($res, qr/Created dbgroup "pg4"/, $t);

## Create a new dbgroup going between A and B
$t = q{Created a new dbgroup (A <=> B)};
$res = $bct->ctl('bucordo add dbgroup pg5 A:source B:source');
like ($res, qr/Created dbgroup "pg5"/, $t);

## Create some new syncs. Only one should be active at a time!
$t = q{Created a new sync for dbgroup pg1};
$res = $bct->ctl('bucordo add sync pgtest1 relgroup=allpk dbs=pg1 status=inactive');
like ($res, qr/Added sync "pgtest1"/, $t);

$t = q{Created a new sync for dbgroup pg2};
$res = $bct->ctl('bucordo add sync pgtest2 relgroup=allpk dbs=pg2 status=inactive autokick=false');
like ($res, qr/Added sync "pgtest2"/, $t);

$t = q{Created a new sync for dbgroup pg3};
$res = $bct->ctl('bucordo add sync pgtest3 relgroup=allpk dbs=pg3 status=inactive autokick=false');
like ($res, qr/Added sync "pgtest3"/, $t);

$t = q{Created a new sync for dbgroup pg4};
$res = $bct->ctl('bucordo add sync pgtest4 relgroup=allpk dbs=pg4 status=inactive autokick=false');
like ($res, qr/Added sync "pgtest4"/, $t);

$t = q{Created a new sync for dbgroup pg5};
$res = $bct->ctl('bucordo add sync pgtest5 relgroup=allpk dbs=pg5 status=inactive autokick=false');
like ($res, qr/Added sync "pgtest5"/, $t);

## Create a table that only exists on A and B: make sure C does not look for it!
$SQL = 'CREATE TABLE mtest(id INT PRIMARY KEY, email TEXT)';
$dbhA->do($SQL);
$dbhA->commit();
$dbhB->do($SQL);
$dbhB->commit();

## Create a copy of table1, but with a different name for same-database replication testing
$SQL = 'CREATE TABLE bucordo_test1_copy (LIKE bucordo_test1)';
$dbhA->do($SQL);
$dbhA->commit();
$dbhB->do($SQL);
$dbhB->commit();

## Create a relgroup for same-database testing
$t = q{Created a new relgroup samerelgroup};
$res = $bct->ctl('bucordo add relgroup samerelgroup bucordo_test1');
like ($res, qr/Created relgroup "samerelgroup"/, $t);

## We want all access to A1 to use the alternate table
$t = q{Created a customname to force usage of bucordo_test1_copy};
$res = $bct->ctl('bucordo add customname bucordo_test1 bucordo_test1_copy db=A1');
like ($res, qr/\Qpublic.bucordo_test1 to bucordo_test1_copy (for database A1)/, $t);

$t = q{Created a new sync for samedb};
$res = $bct->ctl('bucordo add sync samedb relgroup=samerelgroup dbs=A,A1 status=inactive');
like ($res, qr/Added sync "samedb"/, $t);

## Create new relgroups, relations, and a sync
$t = q{Created a new relgroup mrelgroup};
$res = $bct->ctl('bucordo add relgroup mrelgroup mtest');
like ($res, qr/Created relgroup "mrelgroup"/, $t);

$t = q{Created a new sync for mrelgroup};
$res = $bct->ctl('bucordo add sync msync relgroup=mrelgroup dbs=A:source,B:source status=inactive');
like ($res, qr/Added sync "msync"/, $t);

## Add a row to A, to make sure it does not go anywhere with inactive syncs
$bct->add_row_to_database('A', 1);

## Clean out the droptest table for later testing
$dbhA->do('TRUNCATE TABLE droptest_bucordo');
$dbhA->commit();

sub d {
    my $msg = shift || '?';
    my $time = scalar localtime;
    diag "$time: $msg";
}

## Start up bucordo. All syncs are inactive, so nothing should happen,
## and bucordo should exit
$bct->restart_bucordo($dbhX, 'bucordo_stopped');

# Nothing should have been copied to B, C, or D, yet.
$bct->check_for_row([], [qw/B C D/]);

## Activate the pgtest1 and samedb syncs
is $bct->ctl('bucordo update sync pgtest1 status=active'), '', 'Activate pgtest1';
is $bct->ctl('bucordo update sync samedb status=active'),  '', 'Activate samedb';

## Start listening for a syncdone message
## bucordo should fire the sync off right away without a kick
$dbhX->do('LISTEN bucordo_syncdone_pgtest1');
$dbhX->do('LISTEN bucordo_syncdone_samedb');
$dbhX->commit();

## Create a lock file to test the forced file locking
my $lockfile = 'pid/bucordo-force-lock-pgtest1';
open my $fh, '>', $lockfile or die qq{Could not create "$lockfile": $!\n};
close $fh;

## Start up bucordo again
$bct->restart_bucordo($dbhX);

## Wait for our sync to finish
$bct->wait_for_notice($dbhX, 'bucordo_syncdone_pgtest1');

## See if things are on the other databases
$bct->check_for_row([[1]], [qw/ B C D/]);

## Check that our "samedb" process worked
$t = q{Replicating to the same database via customname works};
$SQL = 'SELECT inty FROM bucordo_test1_copy';
$res = $dbhA->selectall_arrayref($SQL);
is_deeply($res, [[1]], $t);

## Make sure triggers and rules did not fire
$SQL = 'SELECT * FROM droptest_bucordo';
$sth = $dbhB->prepare($SQL);
$count = $sth->execute();
if ($count >= 1) {
    diag Dumper $sth->fetchall_arrayref({});
    BAIL_OUT "Found rows ($count) in the droptest table!";
}
$sth->finish();
ok ('No rows found in the droptest table: triggers and rules were disabled');

## Switch to a 2 source sync
is $bct->ctl('bucordo update sync pgtest1 status=inactive'), '', 'Set pgtest1 status=inactive';
is $bct->ctl('bucordo update sync pgtest5 status=active'), '', 'Set pgtest5 status=active';
is $bct->ctl('bucordo deactivate pgtest1'), "Deactivating sync pgtest1\n",
    'Deactivate pgtest1';
is $bct->ctl('bucordo activate pgtest5 0'), "Activating sync pgtest5...OK\n",
    'Activate pgtest5';
## Add some rows to both masters, make sure it goes everywhere
$bct->add_row_to_database('A', 3);
$bct->add_row_to_database('B', 4);

## Kick off the sync.
my $timer_regex = qr/Kick pgtest.*DONE/;
like ($bct->ctl('bucordo kick sync pgtest5 0'), $timer_regex, 'Kick pgtest5')
  or die 'Sync failed, no point continuing';

## All rows should be on A and B.
my $expected = [[1],[3],[4]];
$bct->check_for_row($expected, [qw/A B/]);

# But new rows should not be on C or D.
$bct->check_for_row([[1]], [qw/C D/]);

## Remove the test rows from above
$bct->remove_row_from_database('A', [3,4]);
$bct->remove_row_from_database('B', [3,4]);

## Switch to a 2 source, 2 target sync
is $bct->ctl('bucordo update sync pgtest5 status=inactive'), '',
    'set pgtest5 status=inactive';
is $bct->ctl('bucordo update sync pgtest2 status=active'), '',
    'Set pgtest2 status=active';
is $bct->ctl('bucordo deactivate sync pgtest5'), "Deactivating sync pgtest5\n",
    'Deactivate pgtest5';
is $bct->ctl('bucordo activate sync pgtest2 0'), "Activating sync pgtest2...OK\n",
    'Activate pgtest2';

## Clear the deleted rows above so we have a clean test below
like ($bct->ctl('bucordo kick sync pgtest2 0'), $timer_regex, 'Kick pgtest2')
  or die 'Sync failed, no point continuing';

## Add some rows to both masters, make sure it goes everywhere
for my $num (2..4) {
    $bct->add_row_to_database('A', $num);
}
for my $num (5..10) {
    $bct->add_row_to_database('B', $num);
}

## Kick off the sync. Everything should go to A, B, C, and D
like ($bct->ctl('bucordo kick sync pgtest2 0'), $timer_regex, 'Kick pgtest2')
  or die 'Sync failed, no point continuing';

## Kick off old sync. Should fail, as the sync is inactive
$t = q{Inactive sync pgtest3 should not reject kick};
$res = $bct->ctl('bucordo kick sync pgtest3 0');
like($res, qr/^Cannot kick inactive sync/, $t);

## All rows should be on A, B, C, and D
$expected = [];
push @$expected, [$_] for 1..10;
$bct->check_for_row($expected, [qw/A B C D/]);

## Deactivate pgtest2, bring up pgtest3
is $bct->ctl('bucordo update sync pgtest2 status=inactive'), '',
    'Set pgtest2 status=inactive';
is $bct->ctl('bucordo update sync pgtest3 status=active'), '',
    'Set pgtest3 status=active';
is $bct->ctl('bucordo deactivate sync pgtest2'),
    "Deactivating sync pgtest2\n",
    'Deactivate pgtest2';
is $bct->ctl('bucordo activate sync pgtest3 0'),
    "Activating sync pgtest3...OK\n",
    'Activate pgtest3';

## Kick off the sync to pick up the deltas from the previous runs
like ($bct->ctl('bucordo kick sync pgtest3 0'), $timer_regex, 'Kick pgtest3')
  or die 'Sync failed, no point continuing';

## This one has three sources: A, B, and C. Remove rows from each
$bct->remove_row_from_database('A', 10);
$bct->remove_row_from_database('A', 9);
$bct->remove_row_from_database('A', 8);
$bct->remove_row_from_database('B', 6);
$bct->remove_row_from_database('B', 5);
$bct->remove_row_from_database('B', 4);
$bct->remove_row_from_database('C', 2);
$bct->remove_row_from_database('C', 1);

## Kick it off
like ($bct->ctl('bucordo kick sync pgtest3 0'), $timer_regex, 'Kick pgtest3')
  or die 'Sync failed, no point continuing';

## Only rows left everywhere should be 3 and 7
$bct->check_for_row([[3],[7]], [qw/A B C D/]);

## Cause a conflict: same row on A, B, and C.
$bct->add_row_to_database('A', 1);
$bct->add_row_to_database('B', 1);

$bct->add_row_to_database('A', 2);
$bct->add_row_to_database('B', 2);
$bct->add_row_to_database('C', 2);

## Kick and check everyone is the same
like ($bct->ctl('bucordo kick sync pgtest3 0'), $timer_regex, 'Kick pgtest3')
  or die 'Sync failed, no point continuing';
$bct->check_for_row([[1],[2],[3],[7]], [qw/A B C D/]);

## Change sequence information, make sure it gets out to everyone
if ($dbhA->{pg_server_version} < 80400) {
    $dbhA->do('alter sequence bucordo_test_seq1 restart 25 minvalue 10 maxvalue 8675');
    $dbhB->do('alter sequence bucordo_test_seq2 restart 250 minvalue 100 maxvalue 86753');
} else {
    $dbhA->do('alter sequence bucordo_test_seq1 start 20 restart 25 minvalue 10 maxvalue 8675');
    $dbhB->do('alter sequence bucordo_test_seq2 start 200 restart 250 minvalue 100 maxvalue 86753');
}
$dbhA->commit();
$dbhB->commit();
$dbhC->do(q{SELECT setval('"bucordo_test_seq3"', 12345)});
$dbhC->commit();

like ($bct->ctl('bucordo kick sync pgtest3 0'), $timer_regex, 'Kick pgtest3')
  or die 'Sync failed, no point continuing';

$bct->check_sequences_same([qw/A B C D/]);

## Create a PK conflict and let B "win" due to the timestamp
$SQL = 'UPDATE bucordo_test1 SET data1 = ? WHERE id = ?';
$dbhB->do($SQL, {}, 'Bravo', 3);
$dbhC->do($SQL, undef, 'Charlie', 3);
$dbhA->do($SQL, undef, 'Alpha', 3);
## Order of commits should not matter: the timestamp comes from the start of the transaction
$dbhC->commit();
$dbhB->commit();
$dbhA->commit();

## Just in case, make sure 'bucordo upgrade' does not mess anything up
$bct->ctl('bucordo upgrade');

like ($bct->ctl('bucordo kick sync pgtest3 0'), $timer_regex, 'Kick pgtest3')
  or die 'Sync failed, no point continuing';
$bct->check_for_row([[1],[2],[3],[7]], [qw/A B C D/]);

$SQL = 'SELECT data1 FROM bucordo_test1 WHERE id = ?';
$val = $dbhA->selectall_arrayref($SQL, undef, 3)->[0][0];
$t = 'Conflict resolution respects earliest transaction time for A';
is ($val, 'Charlie', $t);
$t = 'Conflict resolution respects earliest transaction time for B';
$val = $dbhB->selectall_arrayref($SQL, undef, 3)->[0][0];
is ($val, 'Charlie', $t);
$t = 'Conflict resolution respects earliest transaction time for C';
$val = $dbhC->selectall_arrayref($SQL, undef, 3)->[0][0];
is ($val, 'Charlie', $t);

if ($dbhA->{pg_server_version} < 80400) {
    ## Truncate triggers do not work, so we will delete instead
    $bct->delete_all_tables('A');
}
else {
    ## Truncate on A:source goes to all other nodes
    $bct->truncate_all_tables('A');
    ## Just for fun, let C win a truncation "contest"
    $dbhC->do('TRUNCATE TABLE bucordo_test5');
    ## We commit everyone as the truncates will block on open transactions
    $dbhX->commit(); $dbhA->commit(); $dbhB->commit(); $dbhC->commit(); $dbhD->commit();
}

like ($bct->ctl('bucordo kick sync pgtest3 0'), $timer_regex, 'Kick pgtest3')
  or die 'Sync failed, no point continuing';
$bct->check_for_row([], [qw/A B C D/], 'truncate A');

if ($dbhA->{pg_server_version} < 80400) {
    ## Truncate triggers do not work, so we will delete instead
    $bct->delete_all_tables('A');
    ## We do this to emulate all the stuff below
    $bct->add_row_to_database('A', 7);
    $bct->add_row_to_database('A', 3);
  SKIP: {
        skip 'Skipping truncate tests', 5;
    }
    $dbhA->commit();
}
else {
    ## A truncate plus delta rows will truncate all others but keep delta rows
    $bct->add_row_to_database('A', 1);
    $bct->add_row_to_database('B', 2);
    $bct->add_row_to_database('C', 3);
    $bct->add_row_to_database('D', 4);

    ## Order matters: the last one should "win" and thus replicate subsequent changes
    for my $d (qw/ A B C D /) {
        $bct->truncate_all_tables($d);
    }
    ## Now add some things back to each one
    $bct->add_row_to_database('A', 5);
    $bct->add_row_to_database('B', 6);
    $bct->add_row_to_database('C', 7);
    $bct->add_row_to_database('D', 8);
    ## Kick off the sync. C should win (D is target), truncate the others, then propagate '7'
    like ($bct->ctl('bucordo kick sync pgtest3 0'), $timer_regex, 'Kick pgtest3')
      or die 'Sync failed, no point continuing';
    $bct->check_for_row([[7]], [qw/A B C D/], 'truncate D');

}

## Make sure we can go back to normal mode after a truncate
$bct->add_row_to_database('A', 2);
$bct->add_row_to_database('B', 3);

like ($bct->ctl('bucordo kick sync pgtest3 0'), $timer_regex, 'Kick pgtest3')
  or die 'Sync failed, no point continuing';
$bct->check_for_row([[2],[3],[7]], [qw/A B C D/]);

## Tests of customcols
$t = q{add customcols returns expected message};
$res = $bct->ctl('bucordo add customcols bucordo_test1 "SELECT id, data1, inty*30 AS inty"');
like($res, qr/\QNew columns for public.bucordo_test1: "SELECT id, data1, inty*30 AS inty"/, $t);

## Also test the rebuild_index functionality
$res = $bct->ctl('bucordo update sync pgtest3 rebuild_index=1');

## We need to restart bucordo entirely to change this. Someday, a reload sync will be enough.
$bct->restart_bucordo($dbhX);

$bct->add_row_to_database('A', 1);
like ($bct->ctl('bucordo kick sync pgtest3 0'), $timer_regex, 'Kick pgtest3')
  or die 'Sync failed, no point continuing';
$bct->check_for_row([[1],[2],[3],[7]], [qw/A B C/]);
$bct->check_for_row([[1],[2],[3],[7]], [qw/D/], 'customcols', '!test1');
$bct->check_for_row([[2],[3],[7],[30]], [qw/D/], 'customcols', 'test1');

unlink $service_temp_filename;

$bct->ctl('bucordo stop');

pass('Finished with testing');

exit;
