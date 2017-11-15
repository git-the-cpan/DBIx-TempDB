use strict;
use Test::More;
use DBIx::TempDB;

plan skip_all => 'TEST_PG_DSN=postgresql://localhost' unless $ENV{TEST_PG_DSN};

$ENV{DBIX_TEMP_DB_KEEP_DATABASE} = 1;
my $tempdb = DBIx::TempDB->new($ENV{TEST_PG_DSN});
undef $tempdb;    # should normally drop database

my $url = Mojo::URL->new($ENV{DBIX_TEMP_DB_URL});
my $dbh = eval { DBI->connect(DBIx::TempDB->dsn($ENV{DBIX_TEMP_DB_URL})) };
ok !$@, 'DBIX_TEMP_DB_KEEP_DATABASE=1' or diag $@;

# clean up manually
$dbh = DBI->connect(DBIx::TempDB->dsn("$ENV{TEST_PG_DSN}/postgres"));
$dbh->do("drop database " . $url->path->parts->[0]);

done_testing;
