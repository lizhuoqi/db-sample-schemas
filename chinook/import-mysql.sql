-- usage: mysql --user=root -sN < import-mysql.sql
--        or mysql --user=root -sN and `\. import-mysql.sql`


DROP DATABASE IF EXISTS chinook;
CREATE DATABASE chinook;
use chinook;

set @start_stamp = now();
select concat('start at ', date_format(@start_stamp, '%Y-%m-%d %H:%i:%s')) as start_at;

-- doing the real stuff
-- for mysqlimport local file
set global local_infile = 1;
SET foreign_key_checks = 0;

-- ===========================================

select '' as ' ';
SELECT 'CREATING DATABASE STRUCTURE' as ' ';
select '========================================' as ' ';
select '' as ' ';

select '* Dropping everything' as ' ';
source ./sql/drop.sql
select '* Creating tables' as doing;
source ./sql/tables.sql
source ./sql/post-created-mysql.sql
select '* Creating views' as doing;
source ./sql/views.sql

select '' as ' ';
SELECT 'LOADING DATA' as ' ';
select '========================================' as ' ';
select '' as ' ';

-- -- only 8.0.19


select '* LOADING artist' as doing;
source ./data/artist.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/artist.csv

select '* LOADING album' as doing;
source ./data/album.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/album.csv

select '* LOADING employee' as doing;
source ./data/employee.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/employee.csv

select '* LOADING customer' as doing;
source ./data/customer.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/customer.csv

select '* LOADING genre' as doing;
source ./data/genre.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/genre.csv

select '* LOADING invoice' as doing;
source ./data/invoice.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/invoice.csv

select '* LOADING media_type' as doing;
source ./data/media_type.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/media_type.csv

select '* LOADING track' as doing;
source ./data/track.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/track.csv

select '* LOADING invoice_line' as doing;
source ./data/invoice_line.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/invoice_line.csv

select '* LOADING playlist' as doing;
source ./data/playlist.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/playlist.csv

select '* LOADING playlist_trac' as doing;
source ./data/playlist_track.sql
-- \! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 chinook ./data/playlist_track.csv

select '' as ' ';
SELECT 'Counting tables record' as ' ';
select '========================================' as ' ';
select '' as ' ';
source ./sql/result.sql


select '' as ' ';
SELECT '--------------------------------------' as ' ';
select '' as ' ';
select concat('Ended at ', now()) as end_dt;
select concat('It tooks ', timediff( now(), @start_stamp )) as timespan;


SET foreign_key_checks = 1;
\quit -- ? won't work
