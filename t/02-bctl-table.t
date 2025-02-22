#!/usr/bin/env perl
# -*-mode:cperl; indent-tabs-mode: nil-*-

## Test adding, dropping, and changing tables via bucordo
## Tests the main subs: add_table, list_table, update_table, remove_table

use 5.008003;
use strict;
use warnings;
use Data::Dumper;
use lib 't','.';
use DBD::Pg;
use Test::More tests => 46;

use vars qw/$t $res $expected $command $dbhX $dbhA $dbhB $SQL/;

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

## Tests of basic 'add table' usage

$t = 'Add table with no argument gives expected help message';
$res = $bct->ctl('bucordo add table');
like ($res, qr/add table/, $t);

$t = q{Add table fails when no databases have been created yet};
$res = $bct->ctl('bucordo add table foobarz');
like ($res, qr/No databases have been added yet/, $t);

$bct->ctl("bucordo add db A dbname=bucordo_test user=$dbuserA port=$dbportA host=$dbhostA");

$t = q{Add table fails when the table does not exist};
$res = $bct->ctl('bucordo add table foobarz');
like ($res, qr/Did not find matches.*  foobarz/s, $t);

## Clear out each time, gather a list afterwards

sub empty_goat_table() {
    $SQL = 'TRUNCATE TABLE herdmap, herd, goat CASCADE';
    $dbhX->do($SQL);
    $dbhX->commit();
}

empty_goat_table();
$t = q{Add table works for a single valid schema.table entry};
$res = $bct->ctl('bucordo add table public.bucordo_test1');
is ($res, qq{$addtable_msg:\n  public.bucordo_test1\n}, $t);

$t = q{Add table fails for a single invalid schema.table entry};
$res = $bct->ctl('bucordo add table public.bucordo_notest1');
is ($res, qq{$nomatch_msg:\n  public.bucordo_notest1\n}, $t);

$t = q{Add table works for a single valid table entry (no schema)};
$res = $bct->ctl('bucordo add table bucordo_test2');
is ($res, qq{$addtable_msg:\n  public.bucordo_test2\n}, $t);

$t = q{Add table fails for a single invalid table entry (no schema)};
$res = $bct->ctl('bucordo add table bucordo_notest2');
is ($res, qq{$nomatch_msg:\n  bucordo_notest2\n}, $t);

$dbhA->do('DROP SCHEMA IF EXISTS tschema CASCADE');
$dbhA->do('CREATE SCHEMA tschema');
$dbhA->do('CREATE TABLE tschema.bucordo_test4 (a int)');
$dbhA->commit();

$t = q{Add table works for multiple matching valid table entry (no schema)};
$res = $bct->ctl('bucordo add table bucordo_test4');
is ($res, qq{$addtable_msg:\n  public.bucordo_test4\n  tschema.bucordo_test4\n}, $t);

$t = q{Add table works for a single valid middle wildcard entry};
$res = $bct->ctl('bucordo add table B%_test3');
is ($res, qq{$addtable_msg:\n  public.bucordo_test3\n}, $t);

$t = q{Add table works for a single valid beginning wildcard entry};
$res = $bct->ctl('bucordo add table %_test5');
is ($res, qq{$addtable_msg:\n  public.bucordo_test5\n}, $t);

$t = q{Add table works for a single valid ending wildcard entry};
$res = $bct->ctl('bucordo add table drop%');
is ($res, qq{$addtable_msg:\n  public.droptest_bucordo\n}, $t);

$t = q{Add table works for a single valid middle wildcard entry};
$res = $bct->ctl('bucordo add table b%_test6');
is ($res, qq{$addtable_msg:\n  public.bucordo_test6\n}, $t);

$t = q{Add table fails for a single invalid wildcard entry};
$res = $bct->ctl('bucordo add table b%_notest');
is ($res, qq{$nomatch_msg:\n  b%_notest\n}, $t);

$t = q{Add table works for a single valid schema wildcard entry};
$res = $bct->ctl('bucordo add table %.bucordo_test7');
is ($res, qq{$addtable_msg:\n  public.bucordo_test7\n}, $t);

$t = q{Add table fails for a single invalid schema wildcard entry};
$res = $bct->ctl('bucordo add table %.notest');
is ($res, qq{$nomatch_msg:\n  %.notest\n}, $t);

$t = q{Add table works for a single valid table wildcard entry};
$res = $bct->ctl('bucordo add table public.bucard%8');
is ($res, qq{$addtable_msg:\n  public.bucordo_test8\n}, $t);

$t = q{Add table fails for a single invalid table wildcard entry};
$res = $bct->ctl('bucordo add table public.no%test');
is ($res, qq{$nomatch_msg:\n  public.no%test\n}, $t);

$t = q{Add table works for a single valid schema and table wildcard entry};
$res = $bct->ctl('bucordo add table pub%.bucard%9');
is ($res, qq{$addtable_msg:\n  public.bucordo_test9\n}, $t);

$t = q{Add table fails for a single invalid schema and table wildcard entry};
$res = $bct->ctl('bucordo add table pub%.no%test');
is ($res, qq{$nomatch_msg:\n  pub%.no%test\n}, $t);

$t = q{Add table does not re-add existing tables};
$res = $bct->ctl('bucordo add table bucard%');
is ($res, qq{$addtable_msg:\n  public.bucordo space test\n  public.bucordo_test10\n}, $t);

$t = q{'bucordo list tables' returns expected result};
$res = $bct->ctl('bucordo list tables');
$expected =
qr{\d+\.\s* Table: public.bucordo_test3       DB: A  PK: id \(bigint\)\s+
\d+\.\s* Table: public.bucordo space test  DB: A  PK: id \(integer\)\s+
\d+\.\s* Table: public.bucordo_test1       DB: A  PK: id \(smallint\)\s+
\d+\.\s* Table: public.bucordo_test2       DB: A  PK: id\|data1 \(integer\|text\)
\d+\.\s* Table: public.bucordo_test4       DB: A  PK: id \(text\)\s+
\d+\.\s* Table: public.bucordo_test5       DB: A  PK: id space \(date\)\s+
\d+\.\s* Table: public.bucordo_test6       DB: A  PK: id \(timestamp\)\s+
\d+\.\s* Table: public.bucordo_test7       DB: A  PK: id \(numeric\)\s+
\d+\.\s* Table: public.bucordo_test8       DB: A  PK: id \(bytea\)\s+
\d+\.\s* Table: public.bucordo_test9       DB: A  PK: id \(int_unsigned\)\s+
\d+\.\s* Table: public.bucordo_test10      DB: A  PK: id \(timestamptz\)\s+
\d+\.\s* Table: public.droptest_bucordo    DB: A  PK: none\s+
\d+\.\s* Table: tschema.bucordo_test4      DB: A  PK: none\s+
};
like ($res, $expected, $t);

## Remove them all, then try adding in various combinations
empty_goat_table();
$t = q{Add table works with multiple entries};
$res = $bct->ctl('bucordo add table pub%.bucard%9 public.bucordo_test1 nada bucordo3 buca%2');
is ($res, qq{$nomatch_msg:\n  bucordo3\n  nada\n$addtable_msg:\n  public.bucordo_test1\n  public.bucordo_test2\n  public.bucordo_test9\n}, $t);

$t = q{Add table works when specifying the autokick option};
$res = $bct->ctl('bucordo add table bucordo_test5 autokick=true');
is ($res, qq{$addtable_msg:\n  public.bucordo_test5\n}, $t);

$t = q{'bucordo list tables' returns expected result};
$res = $bct->ctl('bucordo list tables');
$expected =
qr{\d+\.\s* Table: public.bucordo_test1  DB: A  PK: id \(smallint\)\s*
\d+\.\s* Table: public.bucordo_test2  DB: A  PK: id\|data1 \(integer\|text\)\s*
\d+\.\s* Table: public.bucordo_test5  DB: A  PK: id space \(date\)\s+ autokick:true\s*
\d+\.\s* Table: public.bucordo_test9  DB: A  PK: id \(int_unsigned\)\s*
};
like ($res, $expected, $t);

$t = q{Add table works when specifying the rebuild_index and autokick options};
$res = $bct->ctl('bucordo add table bucordo_test4 autokick=false rebuild_index=1');
is ($res, qq{$addtable_msg:\n  public.bucordo_test4\n  tschema.bucordo_test4\n}, $t);

$t = q{'bucordo list tables' returns expected result};
$res = $bct->ctl('bucordo list tables');
$expected =
qr{\d+\.\s* Table: public.bucordo_test1   DB: A  PK: id \(smallint\)\s*
\d+\.\s* Table: public.bucordo_test2   DB: A  PK: id|data1 \(integer\|text\)\s*
\d+\.\s* Table: public.bucordo_test4   DB: A  PK: id \(text\)\s* autokick:false\s*rebuild_index:true\s*
\d+\.\s* Table: public.bucordo_test5   DB: A  PK: id space \(date\)\s* autokick:true\s*
\d+\.\s* Table: public.bucordo_test9   DB: A  PK: id \(int_unsigned\)\s*
\d+\.\s* Table: tschema.bucordo_test4  DB: A  PK: none\s*autokick:false  rebuild_index:true\s*
};
like ($res, $expected, $t);

## Remove them all, then try 'all tables'
empty_goat_table();
$t = q{Add all tables};
$res = $bct->ctl('bucordo add all tables -vv --debug');
like ($res, qr{New tables added: 13}, $t);

## Try removing them all via commandline
$t = q{Remove all tables at once};
$res = $bct->ctl('bucordo remove all tables -vv --debug --batch');
like ($res, qr{Removed the following tables}, $t);

## Remove them all, then try 'tables all'
$t = q{Add all tables with reversed words};
$res = $bct->ctl('bucordo add tables all -vv --debug');
like ($res, qr{New tables added: 13}, $t);

## Try removing them all via commandline, reversed args
$t = q{Remove all tables at once with reversed words};
$res = $bct->ctl('bucordo remove tables all -vv --debug --batch');
like ($res, qr{Removed the following tables}, $t);

## Try 'all tables' with tables limit
$t = q{Add all tables with tables limit};
$res = $bct->ctl('bucordo add all tables -t bucordo_test1 -t bucordo_test2 -vv --debug');
like ($res, qr{New tables added: 2\n}, $t);

## Remove them all, then try 'all tables' with schema limit
empty_goat_table();
$t = q{Add all tables with schema limit};
$res = $bct->ctl('bucordo add all tables -n public -vv --debug');
like ($res, qr{New tables added: 12\n}, $t);

## Remove them all, then try 'all tables' with exclude table
empty_goat_table();
$t = q{Add all tables with exclude table};
$res = $bct->ctl('bucordo add all tables -T droptest_bucordo -vv --debug');
like ($res, qr{New tables added: 12}, $t);

## Remove them all, then try 'all tables' with exclude schema
empty_goat_table();
$t = q{Add all tables with exclude schema};
$res = $bct->ctl('bucordo add all tables -N public -vv --debug');
like ($res, qr{New tables added: 1\n}, $t);

empty_goat_table();

$t = q{Add table works when adding to a new relgroup};
$res = $bct->ctl('bucordo add table bucordo_test1 relgroup=foobar');
$expected =
qq{$addtable_msg:
  public.bucordo_test1
Created the relgroup named "foobar"
$newherd_msg "foobar":
  public.bucordo_test1
};
is ($res, $expected, $t);

$t = q{Add table works when adding to an existing relgroup};
$res = $bct->ctl('bucordo add table bucordo_test5 relgroup=foobar');
is ($res, qq{$addtable_msg:\n  public.bucordo_test5\n$oldherd_msg "foobar":\n  public.bucordo_test5\n}, $t);

$t = q{Add table works when adding multiple tables to a new relgroup};
$res = $bct->ctl('bucordo add table "public.Buc*3" %.bucordo_test2 relgroup=foobar2');
$expected =
qq{$addtable_msg:
  public.bucordo_test3
  public.bucordo_test2
Created the relgroup named "foobar2"
$newherd_msg "foobar2":
  public.bucordo_test3
  public.bucordo_test2
};
is ($res, $expected, $t);

$t = q{Add table works when adding multiple tables to an existing relgroup};
$res = $bct->ctl('bucordo add table bucordo_test6 %.%do_test4 relgroup=foobar2');
$expected =
qq{$addtable_msg:
  public.bucordo_test4
  public.bucordo_test6
  tschema.bucordo_test4
$newherd_msg "foobar2":
  public.bucordo_test4
  public.bucordo_test6
  tschema.bucordo_test4
};
is ($res, $expected, $t);

## Tests of basic 'delete table' usage

$t = q{Delete table works for a single entry};
$res = $bct->ctl('bucordo remove table public.bucordo_test4');
$expected =
qq{$deltable_msg:
  public.bucordo_test4
};
is ($res, $expected, $t);

$t = q{Delete table works for multiple entries};
$res = $bct->ctl('bucordo remove table public.bucordo_test3 public.bucordo_test2');
$expected =
qq{$deltable_msg:
  public.bucordo_test3
  public.bucordo_test2
};
is ($res, $expected, $t);

## Tests to list a single table
$t = q{List verbose single table};
$res = $bct->ctl('bucordo list tables -vv public.bucordo_test1');
like ($res, qr/ghost\s+= 0/ , $t);

## Tests of 'update table' usage
$t = q{Update table changes a value properly};
$bct->ctl('bucordo update table public.bucordo_test1 ghost=1');
$res = $bct->ctl('bucordo list tables -vv public.bucordo_test1');
like ($res, qr/ghost\s+= 1/, $t);

$t = q{Update table returns correctly when the value doesn't need changing};
$res = $bct->ctl('bucordo update table public.bucordo_test1 ghost=1');
like ($res, qr/No change needed for ghost/, $t);

$t = q{Update table doesn't try to set "db=" actions};
$res = $bct->ctl('bucordo update table public.bucordo_test1 db=A ghost=1');
unlike ($res, qr/No change needed for db/, $t);

$t = q{Update table correctly filters by db when table exists};
$res = $bct->ctl('bucordo update table public.bucordo_test1 db=A ghost=1');
like ($res, qr/No change needed for ghost/, $t);

$t = q{Update table correctly filters by db when table doesn't exist};
$res = $bct->ctl('bucordo update table public.bucordo_test1 db=B ghost=1');
like ($res, qr/Didn't find any matching tables/, $t);

END {
    $bct->stop_bucordo($dbhX);
    $dbhX and $dbhX->disconnect();
    $dbhA and $dbhA->disconnect();
    $dbhB and $dbhB->disconnect();
}
