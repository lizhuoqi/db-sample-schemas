-- usage: psql < import-postgres.sql
--        or
--        psql and `\i import-postgres.sql`

-- query with no header and rows count.
-- \pset tuples_only on
\t on
DROP DATABASE IF EXISTS employees;
CREATE DATABASE employees;
\c employees;

select current_timestamp as start_stamp \gset
\echo
\echo start at :start_stamp
\echo
-- doing the real stuff

SELECT 'CREATING DATABASE STRUCTURE' as doing;

\i ./sql/drop.sql
\i ./sql/tables.sql
\i ./sql/views.sql

SELECT 'LOADING departments' as doing;
\copy departments from data/departments.csv delimiter ',' csv header;

SELECT 'LOADING employees' as doing;
\copy employees from data/employees.csv delimiter ',' csv header;

SELECT 'LOADING dept_emp' as doing;
\copy dept_emp from data/dept_emp.csv delimiter ',' csv header;

SELECT 'LOADING dept_manager' as doing;
\copy dept_manager from data/dept_manager.csv delimiter ',' csv header;

SELECT 'LOADING salaries' as doing;
\copy salaries from data/salaries.csv delimiter ',' csv header;

SELECT 'LOADING titles' as doing;
\copy titles from data/titles.csv delimiter ',' csv header;

-- -- -- 
SELECT 'Ended at ' || current_timestamp as doing;
select 'It tooks ' || (current_timestamp - TIMESTAMP :'start_stamp');

-- quit cli
\q