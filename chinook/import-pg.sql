-- usage: psql < import-pg.sql
--        or
--        psql and `\i import-pg.sql`

-- query with no header and rows count.
-- \pset tuples_only on
\t on
DROP DATABASE IF EXISTS chinook;
CREATE DATABASE chinook;
\c chinook;

select current_timestamp as start_stamp \gset
\echo '\n' start at :start_stamp '\n'

-- doing the real stuff

-- ===========================================

\echo CREATING DATABASE STRUCTURE
\echo '========================================\n'

\echo * Dropping everything
\i ./sql/drop.sql

-- \echo * Patching
-- \i ./sql/pre-pg.sql

\echo * Creating tables
\i ./sql/tables.sql
-- \i ./sql/post-created-pg.sql

\echo * Creating views
\i ./sql/views.sql

\echo '\n' LOADING Data
\echo '========================================\n'


\echo -n * LOADING artist 
\copy artist from data/artist.csv delimiter ',' csv header;

\echo -n * LOADING album 
\copy album from data/album.csv delimiter ',' csv header;

\echo -n * LOADING employee 
\copy employee from data/employee.csv delimiter ',' csv header;

\echo -n * LOADING customer 
\copy customer from data/customer.csv delimiter ',' csv header;

\echo -n * LOADING genre 
\copy genre from data/genre.csv delimiter ',' csv header;

\echo -n * LOADING invoice 
\copy invoice from data/invoice.csv delimiter ',' csv header;

\echo -n * LOADING media_type 
\copy media_type from data/media_type.csv delimiter ',' csv header;

\echo -n * LOADING track 
\copy track from data/track.csv delimiter ',' csv header;

\echo -n * LOADING invoice_line 
\copy invoice_line from data/invoice_line.csv delimiter ',' csv header;

\echo -n * LOADING playlist 
\copy playlist from data/playlist.csv delimiter ',' csv header;

\echo -n * LOADING playlist_track 
\copy playlist_track from data/playlist_track.csv delimiter ',' csv header;


-- \echo '\nPost Install After Data Loaded'
-- \echo '========================================\n'
-- 
-- \i ./sql/comments.sql

\echo '\nCounting tables record'
\echo '========================================\n'
\i ./sql/result.sql

\echo '--------------------------------------\n'
SELECT 'Ended at ' || current_timestamp as doing;
select 'It tooks ' || (current_timestamp - TIMESTAMP :'start_stamp');

\q