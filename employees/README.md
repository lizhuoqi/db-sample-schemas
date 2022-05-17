
![说明-中文版本](./README_zh.md)

## employees

### Data Model

Here is a sample database with employees as an example. It contains tables such as Department, Employee, Employee Department, Employee Position, Employee Salary, etc.

![table data model / Employees Structure ][er employees ori]

Details about the original mode, see [Employees Structure][er employees ori]

### table in employees

| table name   | comments              | data (rows)
|--------------|-----------------------|-------
| departments  | Departments           | 9
| dept_emp     | employee department   | 331603
| dept_manager | Department Manager    | 24
| employees    | employees             | 300024
| salaries     | Employee Compensation | 2844047
| titles       | Staff positions       | 443308

### views

| View Name | comments
| -------------------|--------
| v_emp_latest_date  | the last date of the employee, including in-service or resignation
| v_current_dept_emp | department employees based on their last status

### where does it come from

The original database is from [Employees Sample Database][mysql sample employees], and its code is published at [test_db][mysql sample employees codebase].

> The original data was created by Fusheng Wang and Carlo Zaniolo at Siemens Corporate Research. The data is in XML format. http://timecenter.cs.aau.dk/software.htm
>
> Giuseppe Masia made the relational schema and Patrick Crews exported the data in relational format.
>
> The database contains about 300,000 employee records with 2.8 million salary entries. The export data is 167 MB, which is not huge, but heavy enough to be non-trivial for testing.
> 
> The data was generated, and as such there are inconsistencies and subtle problems. Rather than removing them, we decided to leave the contents untouched, and use these issues as data cleaning exercises.
>
> -- [where-it-comes-from][where is comes from]
>

### Differences from the original

* *employees.sql* used
* used data from *load_\*.dump* files
* Data has been reordered randomly
* Views and functions in *objects.sql* have not been created yet
* The *test_\*.sh* tests in the original code base cannot be executed

### Prerequisites

Prepare a postgres, sqlite, MySQL database service.

In addition to sqlite, use postgres, MySQL, at least these permissions are required.

    SELECT, INSERT, UPDATE, DELETE,
    CREATE, DROP, RELOAD, REFERENCES,
    INDEX, ALTER, SHOW DATABASES,
    CREATE TEMPORARY TABLES,
    LOCK TABLES, EXECUTE, CREATE VIEW

Generally, if we use the local host for experiments, we use users with high privileges, and these privileges do not require you to pay special attention.

After installing the postgres and mysql databases, configure the *bin* directories of these database programs into the `PATH` of the environment.
sqlite is just an executable file that can be placed in any directory contained in the environment variable `PATH`.

### Install the sample database


1. Download this repository

2. Go to the repository directory on the command line

````
cd PATH_TO_DB_SAMPLE_SCHEMAS/employees
````

3. Unzip the csv data file

````
unzip ./data/data.zip
````

4. Execute the SQL script according to the actual database service used to create tables and import sample data

In order to ensure that the SQL script can be executed repeatedly, the SQL script contains the `DROP` operation DDL of the view and table before executing the `create` operation. Please ignore some errors messages in db cli terminal such as the following, which are telling you, " Dropping non-existent objects".

     "ERROR: view "v_current_dept_emp" does not exist"

On my personal laptop, it takes about 1 minute to execute the script.

    MacBook Pro (13-inch, 2017, Two Thunderbolt 3 ports
    Processor 2.3 GHz Dual Core Intel Core i5
    Memory 8 GB 2133 MHz LPDDR3

#### Install in Postgres service

First, start your postgres database service instance
    
    pg_ctl -D [directory where your postgres example has been initialized] start

Execute on another terminal

    psql < import-postgres.sql

If logged in to psql cli
  
    ➜ psql
    psql (14.2)
    Type "help" for help.
    
    macbook=#\i import-postgres.sql

<details>
  <summary>Results</summary>

    ➜ psql < import-postgres.sql
    DROP DATABASE
    CREATE DATABASE
    You are now connected to database "employees" as user "macbook".
    
    start at 2022-05-17 12:43:38.591187+08
    
     CREATING DATABASE STRUCTURE
    
    psql:./sql/drop.sql:3: ERROR: view "v_current_dept_emp" does not exist
    psql:./sql/drop.sql:4: ERROR: view "v_emp_latest_date" does not exist
    psql:./sql/drop.sql:5: NOTICE: table "dept_emp" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:6: NOTICE: table "dept_manager" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:7: NOTICE: table "titles" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:8: NOTICE: table "salaries" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:9: NOTICE: table "employees" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:10: NOTICE: table "departments" does not exist, skipping
    DROP TABLE
    CREATE TABLE
    CREATE TABLE
    CREATE TABLE
    CREATE TABLE
    CREATE TABLE
    CREATE TABLE
    CREATE VIEW
    CREATE VIEW
     LOADING departments
    
    COPY 9
     LOADING employees
    
    COPY 300024
     LOADING dept_emp
    
    COPY 331603
     LOADING dept_manager
    
    COPY 24
     LOADING salaries
    
    COPY 2844047
     LOADING titles
    
    COPY 443308
     Ended at 2022-05-17 12:44:33.367527+08
    
     It took 00:00:54.777496
    
    
     Counting tables record
    
     dept_emp | 331603
     dept_manager | 24
     titles | 443308
     salaries | 2844047
     employees | 300024
     departments | 9
</details>


#### Install in sqlite

Execute in terminal

    sqlite3 employees.sqlite < import-sqlite.sql

If you are already at the sqlite3 prompt

    ➜ sqlite3 employees.sqlite
    SQLite version 3.37.0 2021-12-09 01:34:53
    Enter ".help" for usage hints.
    sqlite > .read import-sqlite.sql


If the *employees.sqlite* file does not exist, sqlite3 will automatically create it.

<details>
  <summary>Results</summary>

  ````
  CREATING DATABASE STRUCTURE
  Error: near line 3: in prepare, no such view: v_current_dept_emp (1)
  Error: near line 4: in prepare, no such view: v_emp_latest_date (1)
  LOADING departments
  LOADING employees
  LOADING titles
  LOADING dept_emp
  LOADING dept_manager
  LOADING salaries
  It took 00:48.000
  
  Counting tables record
  dept_emp|331603
  dept_manager|24
  titles|443308
  salaries|2844047
  employees|300024
  departments|9
  ````
</details>


#### install in mysql service

First, start your mysql database service instance

    mysqld --datadir=mysql database data directory

Execute in another command line terminal

    mysql --user=root --force -sN < import-postgres.sql

If you have logged in under mysql cli, you can do this
  
    ➜ mysql --user=root -sN
    mysql>\.import-mysql.sql
    or
    mysql> source import-mysql.sql



<details>
  <summary>
    Results
  </summary>
  
  ````
  ➜ mysql --user=root --force -sN < import-mysql.sql
  start at 2022-05-17 11:52:50
  CREATING DATABASE STRUCTURE
  Dropping everything
  ERROR 1051 (42S02) at line 3 in file: './sql/drop.sql': Unknown table 'employees.v_current_dept_emp'
  ERROR 1051 (42S02) at line 4 in file: './sql/drop.sql': Unknown table 'employees.v_emp_latest_date'
  Creating tables
  storage engine: InnoDB
  Creating views

  LOADING departments
  employees.departments: Records: 9 Deleted: 0 Skipped: 0 Warnings: 0

  LOADING employees
  employees.employees: Records: 300024 Deleted: 0 Skipped: 0 Warnings: 0
  LOADING dept_emp
  employees.dept_emp: Records: 331603 Deleted: 0 Skipped: 0 Warnings: 0
  LOADING dept_manager
  employees.dept_manager: Records: 24 Deleted: 0 Skipped: 0 Warnings: 0
  LOADING salaries
  employees.salaries: Records: 2844047 Deleted: 0 Skipped: 0 Warnings: 0
  LOADING titles
  employees.titles: Records: 443308 Deleted: 0 Skipped: 0 Warnings: 0

  Ended at 2022-05-17 11:53:58
  It took 00:01:08.000000

  Counting tables record
  dept_emp 331603
  dept_manager 24
  titles 443308
  salaries 2844047
  employees 300024
  departments 9
  ````

</details>

### DISCLAIMER

The data in the example is fabricated and it does not correspond to anyone in the real world. Any similarity is purely coincidental.

### Licensing

This work is licensed under the [Attribution-Share Alike 3.0 Unlocalized Version (CC BY-SA 3.0)][cc-by-sa] license.

[![CC BY-SA 3.0][cc-by-sa-image]][cc-by-sa]

<!-- reference links -->

[license]: https://creativecommons.org/licenses/by-sa/3.0/deed.zh
[where is comes from]: https://github.com/datacharmer/test_db#where-it-comes-from
[mysql sample employees]: https://dev.mysql.com/doc/employee/en/
[mysql sample employees codebase]: https://github.com/datacharmer/test_db
[er employees ori]: ./images/employees-schema.png
[er employees]: ./images/er-employees-en.png
[er employees structure]: https://dev.mysql.com/doc/employee/en/sakila-structure.html

[cc-by-sa]: https://creativecommons.org/licenses/by-sa/3.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/3.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%203.0-lightgrey.svg
