-- usage: mysql --user=root -sN < import-mysql.sql
--        or mysql --user=root -sN and `\. import-mysql.sql`


DROP DATABASE IF EXISTS sakila1;
CREATE DATABASE sakila1;
use sakila1;

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

-- only 8.0.19
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/actor.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/category.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/language.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/film.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/film_actor.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/film_category.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/film_text.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/country.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/city.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/address.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/store.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/customer.csv
source ./data/staff-mysql.sql
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/inventory.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/rental.csv
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 sakila1 ./data/payment.csv

select '' as ' ';
SELECT 'Post Install After Data Loaded' as ' ';
select '========================================' as ' ';
select '' as ' ';

source ./sql/post-data-loaded-mysql.sql

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
