-- usage: sqlite3 chinook.sqlite
-- and execute command `.read import-sqlite.sql` in sqlite interpretor cli.

-- sqlite foreign key support is off by default
PRAGMA foreign_keys = OFF;   
-- store temp table in memory, not on disk
PRAGMA temp_store = 2;      
select 'start at :' || current_timestamp;
create temp table variable as
select 'now' as key, current_timestamp as value;

-- ===========================================
-- doing the real stuff

SELECT '
CREATING DATABASE STRUCTURE
========================================
';

select '* Dropping everything' as doing;
.read ./sql/drop.sql
select '* Creating tables' as doing;
.read ./sql/tables.sql
select '* Creating views' as doing;
.read ./sql/views.sql


SELECT '
LOADING Data
========================================
';

select '* LOADING artist' as doing;
-- .read ./data/artist.sql
.import --csv --skip 1 data/artist.csv artist

select '* LOADING album' as doing;
-- .read ./data/album.sql
.import --csv --skip 1 data/album.csv album

select '* LOADING employee' as doing;
-- .read ./data/employee.sql
.import --csv --skip 1 data/employee.csv employee

select '* LOADING customer' as doing;
-- .read ./data/customer.sql
.import --csv --skip 1 data/customer.csv customer

select '* LOADING genre' as doing;
-- .read ./data/genre.sql
.import --csv --skip 1 data/genre.csv genre

select '* LOADING invoice' as doing;
-- .read ./data/invoice.sql
.import --csv --skip 1 data/invoice.csv invoice

select '* LOADING media_type' as doing;
-- .read ./data/media_type.sql
.import --csv --skip 1 data/media_type.csv media_type

select '* LOADING track' as doing;
-- .read ./data/track.sql
.import --csv --skip 1 data/track.csv track

select '* LOADING invoice_line' as doing;
-- .read ./data/invoice_line.sql
.import --csv --skip 1 data/invoice_line.csv invoice_line

select '* LOADING playlist' as doing;
-- .read ./data/playlist.sql
.import --csv --skip 1 data/playlist.csv playlist

select '* LOADING playlist_trac' as doing;
-- .read ./data/playlist_track.sql
.import --csv --skip 1 data/playlist_track.csv playlist_track


-- SELECT '
-- Post Install After Data Loaded
-- ========================================
-- ';
-- .read ./sql/post-data-loaded-sqlite.sql


SELECT '
Counting tables record
========================================
';
.mode markdown
.read ./sql/result.sql
.mode list

SELECT '
--------------------------------------

Ended at ' || current_timestamp || '
';


select strftime(
           'It tooks %M:%f'
         , JULIANDAY(current_timestamp) - JULIANDAY(value)
       ) as duration
from   variable
where  key = 'now';

drop table variable;

PRAGMA foreign_keys = ON; 

.quit