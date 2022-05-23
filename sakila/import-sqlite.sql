-- usage: sqlite3 employees.sqlite
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

.read ./sql/drop.sql
select '* Creating tables' as doing;
.read ./sql/tables.sql
.read ./sql/post-created-sqlite.sql
select '* Creating views' as doing;
.read ./sql/views.sql

SELECT '
LOADING Data
========================================
';

select '* LOADING actor' as doing;
.import --csv --skip 1 data/actor.csv actor
select '* LOADING category' as doing;
.import --csv --skip 1 data/category.csv category
select '* LOADING language' as doing;
.import --csv --skip 1 data/language.csv language
select '* LOADING film' as doing;
.import --csv --skip 1 data/film.csv film
select '* LOADING film_actor' as doing;
.import --csv --skip 1 data/film_actor.csv film_actor
select '* LOADING film_category' as doing;
.import --csv --skip 1 data/film_category.csv film_category
select '* LOADING film_text' as doing;
.import --csv --skip 1 data/film_text.csv film_text
select '* LOADING country' as doing;
.import --csv --skip 1 data/country.csv country
select '* LOADING city' as doing;
.import --csv --skip 1 data/city.csv city
select '* LOADING address' as doing;
.import --csv --skip 1 data/address.csv address
select '* LOADING store' as doing;
.import --csv --skip 1 data/store.csv store
select '* LOADING customer' as doing;
.import --csv --skip 1 data/customer.csv customer
select '* LOADING staff' as doing;
.read ./data/staff-mysql.sql
select '* LOADING inventory' as doing;
.import --csv --skip 1 data/inventory.csv inventory
select '* LOADING rental' as doing;
.import --csv --skip 1 data/rental.csv rental
select '* LOADING payment' as doing;
.import --csv --skip 1 data/payment.csv payment


SELECT '
Post Install After Data Loaded
========================================
';
.read ./sql/post-data-loaded-sqlite.sql


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