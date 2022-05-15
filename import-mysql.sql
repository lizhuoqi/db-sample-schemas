DROP DATABASE IF EXISTS employees1;
CREATE DATABASE employees1;
use employees1;

set @start_stamp = now();
select concat('start at ', date_format(@start_stamp, '%Y-%m-%d %H:%i:%s')) as start_at;

-- doing the real stuff
-- for mysqlimport local file
set global local_infile = 1;
SET foreign_key_checks = 0;

SELECT 'CREATING DATABASE STRUCTURE' as doing;

select 'Dropping everything' as doing;
source drop.sql
select 'Creating tables' as doing;
source tables.sql
select 'Creating views' as doing;
source views.sql
select '' as " ";

SELECT 'LOADING departments' as doing;
-- only 8.0.19
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 employees ./data/departments.csv

select '' as " ";
SELECT 'LOADING employees' as doing;
-- only 8.0.19
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 employees ./data/employees.csv

SELECT 'LOADING dept_emp' as doing;
-- only 8.0.19
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 employees ./data/dept_emp.csv

SELECT 'LOADING dept_manager' as doing;
-- only 8.0.19
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 employees ./data/dept_manager.csv

SELECT 'LOADING salaries' as doing;
-- only 8.0.19
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 employees ./data/salaries.csv

SELECT 'LOADING titles' as doing;
-- only 8.0.19
\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 employees ./data/titles.csv


-- ----
select '' as " ";
select concat('Ended at ', now()) as end_dt;
select concat('It tooks ', timediff( now(), @start_stamp )) as timespan;

SET foreign_key_checks = 1;

\quit -- ? won't work
