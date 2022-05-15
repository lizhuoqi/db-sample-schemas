-- usage: sqlite3 employees.sqlite
-- and execute command `.read import-sqlite.sql` in sqlite interpretor cli.

-- sqlite foreign key support is off by default
PRAGMA foreign_keys = ON;   
-- store temp table in memory, not on disk
PRAGMA temp_store = 2;      

create temp table variable as
select 'now' as key, current_timestamp as value;

-- doing the real stuff

SELECT 'CREATING DATABASE STRUCTURE' as doing;

.read ./sql/drop.sql
.read ./sql/tables.sql
.read ./sql/views.sql

SELECT 'LOADING departments' as doing;
.import --csv --skip 1  data/departments.csv departments
SELECT 'LOADING employees' as doing;
.import --csv --skip 1  data/employees.csv employees
SELECT 'LOADING titles' as doing;
.import --csv --skip 1  data/titles.csv titles
SELECT 'LOADING dept_emp' as doing;
.import --csv --skip 1  data/dept_emp.csv dept_emp
SELECT 'LOADING dept_manager' as doing;
.import --csv --skip 1  data/dept_manager.csv dept_manager
SELECT 'LOADING salaries' as doing;
.import --csv --skip 1  data/salaries.csv salaries

-- 
select strftime(
	       'It tooks %M:%f'
         , JULIANDAY(current_timestamp) - JULIANDAY(value)
       ) as duration
from   variable
where  key = 'now';

drop table variable;

.quit