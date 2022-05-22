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

SELECT 'CREATING DATABASE STRUCTURE' as doing;

select 'Dropping everything' as doing;
source ./sql/drop.sql
select 'Creating tables' as doing;
source ./sql/tables.sql
source ./sql/post-created-mysql.sql
select 'Creating views' as doing;
source ./sql/views.sql
select '' as " ";

-- ===========================================

SELECT 'LOADING departments' as doing;
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

-- ===========================================

select '' as " ";
select 'Setting after data loaded. e.g. auto_increment with sequence' as doing;
source ./sql/post-data-loaded-mysql.sql

-- ===========================================

select '' as " ";
select concat('Ended at ', now()) as end_dt;
select concat('It tooks ', timediff( now(), @start_stamp )) as timespan;

SET foreign_key_checks = 1;

select '' as " ";
select 'Counting tables record' as doing;
source ./sql/result.sql

\quit -- ? won't work
