#!/usr/bin/env perl
# -*-mode:cperl; indent-tabs-mode: nil-*-

## Test bucordo_delta and bucordo_track table tasks

use 5.008003;
use strict;
use warnings;
use Data::Dumper;
use lib 't','.';
use DBD::Pg;
use Test::More;
use MIME::Base64;

use vars qw/ $bct $dbhX $dbhA $dbhB $dbhC $res $command $t $SQL %pkey %sth %sql $sth $count/;

use bucordoTesting;
$bct = bucordoTesting->new() or BAIL_OUT "Creation of bucordoTesting object failed\n";
$location = '';

my $numtabletypes = keys %tabletype;
my $numsequences = keys %sequences;
plan tests => 164;

pass("*** Beginning delta tests");

END {
    $bct and $bct->stop_bucordo($dbhX);
    $dbhX and  $dbhX->disconnect();
    $dbhA and $dbhA->disconnect();
    $dbhB and $dbhB->disconnect();
    $dbhC and $dbhC->disconnect();
}

## Get Postgres databases A, B, and C created
$dbhA = $bct->repopulate_cluster('A');
$dbhB = $bct->repopulate_cluster('B');
$dbhC = $bct->repopulate_cluster('C');

## Create a bucordo database, and install bucordo into it
$dbhX = $bct->setup_bucordo('A');

## Tell bucordo about these databases (one source and two targets)
for my $name (qw/ A B C /) {
    $t = "Adding database from cluster $name works";
    my ($dbuser,$dbport,$dbhost) = $bct->add_db_args($name);
    $command = "bucordo add db $name dbname=bucordo_test user=$dbuser port=$dbport host=$dbhost";
    $res = $bct->ctl($command);
    like ($res, qr/Added database "$name"/, $t);
}

## Put all pk tables into a relgroup
$t = q{Adding all PK tables on the master works};
$res = $bct->ctl(q{bucordo add tables '*bucordo*test*' '*bucordo*test*' db=A relgroup=trelgroup pkonly});
like ($res, qr/Created the relgroup named "trelgroup".*are now part of/s, $t);

## Add all sequences, and add them to the newly created relgroup
$t = q{Adding all sequences on the master works};
$res = $bct->ctl("bucordo add all sequences relgroup=trelgroup");
like ($res, qr/New sequences added: \d/, $t);

## Create a new dbgroup going from A to B and C
$t = q{Created a new dbgroup};
$res = $bct->ctl(q{ bucordo add dbgroup pg A:source B:target C:target });
like ($res, qr/Created dbgroup "pg"/, $t);

## Create a new sync
$t = q{Created a new sync};
$res = $bct->ctl(q{ bucordo add sync dtest relgroup=trelgroup dbs=pg autokick=false });
like ($res, qr/Added sync "dtest"/, $t);

## Make sure the bucordo_delta and bucordo_track tables are empty
for my $table (sort keys %tabletype) {

    my $tracktable = "track_public_$table";
    my $deltatable = "delta_public_$table";

    $t = "The track table $tracktable is empty";
    $SQL = qq{SELECT 1 FROM bucordo."$tracktable"};
    $count = $dbhA->do($SQL);
    is ($count, '0E0', $t);

    $t = "The delta table $deltatable is empty";
    $SQL = qq{SELECT 1 FROM bucordo."$deltatable"};
    $count = $dbhA->do($SQL);
    is ($count, '0E0', $t);
}

## Start up bucordo with this new sync
$bct->restart_bucordo($dbhX);

## Add a row to A
$bct->add_row_to_database('A', 1);

## Make sure that bucordo_track is empty and bucordo_delta has the expected value
for my $table (sort keys %tabletype) {

    my $tracktable = "track_public_$table";
    my $deltatable = "delta_public_$table";

    $t = "The track table $tracktable is empty";
    $SQL = qq{SELECT 1 FROM bucordo."$tracktable"};
    $count = $dbhA->do($SQL);
    is ($count, '0E0', $t);

    my $pkeyname = $table =~ /test5/ ? q{"id space"} : 'id';

    $t = "The delta table $deltatable contains the correct id";
    $SQL = qq{SELECT $pkeyname FROM bucordo."$deltatable"};
    $dbhA->do(q{SET TIME ZONE 'UTC'});
    $res = $dbhA->selectall_arrayref($SQL);
    my $type = $tabletype{$table};
    my $val1 = $val{$type}{1};
    is_deeply ($res, [[$val1]], $t) or die;
}

## Kick off the sync
$bct->ctl('bucordo kick dtest 0');

## All rows should be on A, B, and C
my $expected = [[1]];
$bct->check_for_row($expected, [qw/A B C/]);

## Make sure that bucordo_track now has a row
for my $table (sort keys %tabletype) {

    my $tracktable = "track_public_$table";

    $t = "The track table $tracktable contains the proper entry";
    $SQL = qq{SELECT target FROM bucordo."$tracktable"};
    $res = $dbhA->selectall_arrayref($SQL);
    is_deeply ($res, [['dbgroup pg']], $t);

}

## Run the purge program
$bct->ctl('bucordo purge');

for my $table (sort keys %tabletype) {

    my $tracktable = "track_public_$table";
    my $deltatable = "delta_public_$table";

    $t = "The track table $tracktable contains no entries post purge";
    $SQL = qq{SELECT 1 FROM bucordo."$tracktable"};
    $count = $dbhA->do($SQL);
    is ($count, '0E0', $t);

    $t = "The delta table $deltatable contains no entries post purge";
    $SQL = qq{SELECT 1 FROM bucordo."$deltatable"};
    $count = $dbhA->do($SQL);
    is ($count, '0E0', $t);

}

## Create a doubled up entry in the delta table (two with same timestamp and pk)
$bct->add_row_to_database('A', 22, 0);
$bct->add_row_to_database('A', 28, 0);
$dbhA->commit();

## Check for two entries per table
for my $table (sort keys %tabletype) {

    my $tracktable = "track_public_$table";
    my $deltatable = "delta_public_$table";

    $t = "The track table $tracktable is empty";
    $SQL = qq{SELECT 1 FROM bucordo."$tracktable"};
    $count = $dbhA->do($SQL);
    is ($count, '0E0', $t);

    $t = "The delta table $deltatable contains two entries";
    $SQL = qq{SELECT 1 FROM bucordo."$deltatable"};
    $count = $dbhA->do($SQL);
    is ($count, 2, $t);

}

## Kick it off
$bct->ctl('bucordo kick dtest 0');

## Run the purge program
$bct->ctl('bucordo purge');

for my $table (sort keys %tabletype) {

    my $tracktable = "track_public_$table";
    my $deltatable = "delta_public_$table";

    $t = "The track table $tracktable contains no entries post purge";
    $SQL = qq{SELECT 1 FROM bucordo."$tracktable"};
    $count = $dbhA->do($SQL);
    is ($count, '0E0', $t);

    $t = "The delta table $deltatable contains no entries post purge";
    $SQL = qq{SELECT 1 FROM bucordo."$deltatable"};
    $count = $dbhA->do($SQL);
    is ($count, '0E0', $t);

}

exit;
