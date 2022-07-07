#!/usr/bin/env perl
# -*-mode:cperl; indent-tabs-mode: nil-*-

## Test adding, dropping, and changing databases via bucordo
## Tests the main subs: add_database, list_databases, update_database, remove_database

use 5.008003;
use strict;
use warnings;
use Data::Dumper;
use lib 't','.';
use DBD::Pg;
use Test::More tests => 1;

use vars qw/$t $res $command $dbhX $dbhA $dbhB/;

use bucordoTesting;
my $bct = bucordoTesting->new({notime=>1})
    or BAIL_OUT "Creation of bucordoTesting object failed\n";
$location = '';

## Make sure A and B are started up
$dbhA = $bct->repopulate_cluster('A');
$dbhB = $bct->repopulate_cluster('B');

## Create a bucordo database, and install bucordo into it
$dbhX = $bct->setup_bucordo('A');

## Grab connection information for each database
my ($dbuserA,$dbportA,$dbhostA) = $bct->add_db_args('A');
my ($dbuserB,$dbportB,$dbhostB) = $bct->add_db_args('B');

pass('No tests for this yet');

exit;

END {
    $bct->stop_bucordo($dbhX);
    $dbhX and $dbhX->disconnect();
    $dbhA and $dbhA->disconnect();
    $dbhB and $dbhB->disconnect();
}
