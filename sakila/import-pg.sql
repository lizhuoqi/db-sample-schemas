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
\echo '\n' start at :start_stamp '\n'

-- doing the real stuff

-- ===========================================

\echo CREATING DATABASE STRUCTURE
\echo '========================================\n'

\echo * Dropping everything
\i ./sql/drop.sql

\echo * Patching
\i ./sql/pre-pg.sql

\echo * Creating tables
\i ./sql/tables.sql
\i ./sql/post-created-pg.sql

\echo * Creating views
\i ./sql/views.sql

\echo '\n' LOADING Data
\echo '========================================\n'

\echo -n * LOADING actor
\copy actor from data/actor.csv delimiter ',' csv header;

\echo -n * LOADING category
\copy category from data/category.csv delimiter ',' csv header;

\echo -n * LOADING language
\copy language from data/language.csv delimiter ',' csv header;

\echo -n * LOADING film
\copy film from data/film.csv delimiter ',' csv header NULL '\N';

\echo -n * LOADING film_actor
\copy film_actor from data/film_actor.csv delimiter ',' csv header;

\echo -n * LOADING film_category
\copy film_category from data/film_category.csv delimiter ',' csv header;

\echo -n * LOADING film_text
\copy film_text from data/film_text.csv delimiter ',' csv header;

\echo -n * LOADING country
\copy country from data/country.csv delimiter ',' csv header;

\echo -n * LOADING city
\copy city from data/city.csv delimiter ',' csv header;

\echo -n * LOADING address
\copy address from data/address.csv delimiter ',' csv header;

\echo -n * LOADING store
\copy store from data/store.csv delimiter ',' csv header;

\echo -n * LOADING customer
\copy customer from data/customer.csv delimiter ',' csv header;

\echo * LOADING staff
\i ./data/staff-pg.sql

\echo -n * LOADING inventory
\copy inventory from data/inventory.csv delimiter ',' csv header;

\echo -n * LOADING rental
\copy rental from data/rental.csv delimiter ',' csv header  NULL '\N';

\echo -n * LOADING payment
\copy payment from data/payment.csv delimiter ',' csv header  NULL '\N';


\echo '\nPost Install After Data Loaded'
\echo '========================================\n'

\i ./sql/post-data-loaded-pg.sql
\i ./sql/comments.sql

\echo '\nCounting tables record'
\echo '========================================\n'
\i ./sql/result.sql

\echo '--------------------------------------\n'
SELECT 'Ended at ' || current_timestamp as doing;
select 'It tooks ' || (current_timestamp - TIMESTAMP :'start_stamp');

\q