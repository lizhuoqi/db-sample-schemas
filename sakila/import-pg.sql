-- usage: psql < import-pg.sql
--        or
--        psql and `\i import-pg.sql`

-- query with no header and rows count.
-- \pset tuples_only on
\t on
DROP DATABASE IF EXISTS sakila;
CREATE DATABASE sakila;
\c sakila;

select current_timestamp as start_stamp \gset
\echo
\echo start at :start_stamp
\echo

-- doing the real stuff

-- ===========================================

SELECT 'CREATING DATABASE STRUCTURE' as doing;


select 'Dropping everything' as doing;
\i ./sql/drop.sql
select 'Patching' as doing;
\i ./sql/pre-pg.sql
select 'Creating tables' as doing;
\i ./sql/tables.sql
\i ./sql/post-created-pg.sql
select 'Creating views' as doing;
\i ./sql/views.sql
select '' as " ";
-- ===========================================

select 'LOADING actor' as doing;
\copy actor from data/actor.csv delimiter ',' csv header;
select 'LOADING category' as doing;
\copy category from data/category.csv delimiter ',' csv header;
select 'LOADING language' as doing;
\copy language from data/language.csv delimiter ',' csv header;
select 'LOADING film' as doing;
\copy film from data/film.csv delimiter ',' csv header NULL '\N';
select 'LOADING film_actor' as doing;
\copy film_actor from data/film_actor.csv delimiter ',' csv header;
select 'LOADING film_category' as doing;
\copy film_category from data/film_category.csv delimiter ',' csv header;
select 'LOADING film_text' as doing;
\copy film_text from data/film_text.csv delimiter ',' csv header;
select 'LOADING country' as doing;
\copy country from data/country.csv delimiter ',' csv header;
select 'LOADING city' as doing;
\copy city from data/city.csv delimiter ',' csv header;
select 'LOADING address' as doing;
\copy address from data/address.csv delimiter ',' csv header;
select 'LOADING store' as doing;
\copy store from data/store.csv delimiter ',' csv header;
select 'LOADING customer' as doing;
\copy customer from data/customer.csv delimiter ',' csv header;
select 'LOADING staff' as doing;
\i ./data/staff-pg.sql
select 'LOADING inventory' as doing;
\copy inventory from data/inventory.csv delimiter ',' csv header;
select 'LOADING rental' as doing;
\copy rental from data/rental.csv delimiter ',' csv header  NULL '\N';
select 'LOADING payment' as doing;
\copy payment from data/payment.csv delimiter ',' csv header  NULL '\N';

-- ===========================================

\i ./sql/post-data-loaded-pg.sql

-- ===========================================

SELECT 'Ended at ' || current_timestamp as doing;
select 'It tooks ' || (current_timestamp - TIMESTAMP :'start_stamp');

\echo
select 'Counting tables record' as doing;
\i ./sql/result.sql

-- quit cli
\q