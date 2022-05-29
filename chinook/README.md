
> translated by google-translate

## chinook

### Data Model

This is an example of music album sales. It contains tables such as Albums, Artists, Customers, Employees, Invoices, etc.

![table data model][chinook er]


### Tables in chinook

| table name | comments | data (rows)
|----------------|-------------|------------|
| artist | Artist | 275 |
| album | Albums | 347 |
| employee | employee | 8 |
| customer | customer | 59 |
| genre | Musical style | 25 |
| invoice | invoice | 412 |
| media_type | Media file type | 5 |
| track | Tracks | 3503 |
| invoice_line | invoice line | 2240 |
| playlist | playlist | 18 |
| playlist_track | playlist track | 8715 |


### where does it come from

The sakila sample database is from [Chinook Database - Version 1.4][chinook sample database].

> Chinook is a sample database available for SQL Server, Oracle, MySQL, etc. It can be created by running a single SQL script. Chinook database is an alternative to the Northwind database, being ideal for demos and testing ORM tools targeting single and multiple database servers.


### Differences from the original

* *All 11 tables and data in Chinook_postgres.sql*
* *employee.birth_date*, *employee.hire_date* field data type is adjusted to `datetime`, which is the value range of individual dates that exceed the mysql timestamp type.
* * Identifiers are uniformly named in lower-snakecase (using "[]", "\`\`", camelcase to write sql is too unhuman), more convenient for keystrokes
* Data has been reordered randomly
* Only tables and data from the sample database are used. Other *C#* applications do not use and will not in the future.

### Adjustments for postgres, sqlite3, mysql compatibility


| serial number | original script | postgres | sqlite3 | mysql
|-----|-------------------------------|---------- |------------|------
| 1 | employee.birth_date timestamp | timestamp | timestamp | datetime
| 2 | employee.hire_date timestamp | timestamp | timestamp | datetime

<!-- todo timestamp with timezone -->

### Prerequisites

Prepare a postgres, sqlite, MySQL database service. How to install database services, see ["How to quickly set up a usable SQL environment"][lab]

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
cd PATH_TO_DB_SAMPLE_SCHEMAS/chinook
````

3. Unzip the csv data file

````
unzip ./data/data.zip
````

4. Execute the SQL script according to the actual database service used to create tables and import sample data

In order to ensure that the SQL script can be executed repeatedly, the SQL script contains the `DROP` operation DDL of the view and table before executing the `create` operation. Please ignore the following error messages in the command line terminal. It's just telling you, "delete non-existent objects".

    Similar to "ERROR: Table 'chinook.album' doesn't exist"

On my personal laptop, the execution of the script completes in under 3 seconds.

    MacBook Pro (13-inch, 2017, Two Thunderbolt 3 ports
    Processor 2.3 GHz Dual Core Intel Core i5
    Memory 8 GB 2133 MHz LPDDR3


> The information printed by the command line terminal when executing the script is too long. The following uses `... 🥱 ...` to replace some non-critical information.

<!-- Special article on todo null handling -->

This sample database provides two data loading methods, using the text file loading tool of the database or the pure SQL method of *insert ... values()*. Both methods have their own advantages and disadvantages.

*insert ... values()* has the best compatibility, postgres, mysql, sqlite3 can be used, but its efficiency is lower than the direct file loading method. This example chooses a compromise:


Database | Load Method | Description
----------|---------------|------------
postgres | `\copy` | Null values ​​in csv text do not need special handling, such as ",,"
mysql | `insert ...` sql | default
mysql | mysqlimport | Because mysqlimport will perform "zero value" conversion on the null value, the null value of the character type field becomes an empty string (''), and the value of the numeric type field is set to "0".
sqlite3 | .import | The default method, but due to the null value problem, the field will be set to an empty string, `is null` is invalid, and `= ''`
sqlite3 | `insert ...` sql | is much slower than *.import*.

To start a non-default mode, use the *import-\*.sql* script.


#### Install in Postgres service

First, start your postgres database service instance
    
    pg_ctl -D [directory where your postgres example has been initialized] start

Execute on another command line terminal

    psql < import-pg.sql

If logged in to psql cli
  
    ➜ psql
    psql (14.2)
    Type "help" for help.
    
    macbook=#\i import-pg.sql

<details>
  <summary>Results</summary>

 
```
~/youwu.today/sqllab/sample/db-sample-schemas/chinook git:(develop)
➜ psql < import-pg.sql
ERROR: database "chinook" is being accessed by other users
DETAIL: There are 2 other sessions using the database.
ERROR: database "chinook" already exists
You are now connected to database "chinook" as user "macbook".

 start at 2022-05-26 14:23:15.915499+08

CREATING DATABASE STRUCTURE
===========================================

- Dropping everything
DROP TABLE
DROP TABLE
DROP TABLE
DROP TABLE
DROP TABLE
DROP TABLE
DROP TABLE
DROP TABLE
DROP TABLE
DROP TABLE
DROP TABLE
- Creating tables
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
- Creating views

 LOADING Data
===========================================

- LOADING artistCOPY 275
- LOADING albumCOPY 347
- LOADING employeeCOPY 8
- LOADING customerCOPY 59
- LOADING genreCOPY 25
- LOADING invoiceCOPY 412
- LOADING media_typeCOPY 5
- LOADING trackCOPY 3503
- LOADING invoice_lineCOPY 2240
- LOADING playlistCOPY 18
- LOADING playlist_trackCOPY 8715

Post Install After Data Loaded
===========================================

COMMENT

... 🥱 ...

COMMENT

Counting tables record
===========================================

 artist | 275
 album | 347
 employee | 8
 customer | 59
 genre | 25
 invoice| 412
 media_type | 5
 track | 3503
 invoice_line | 2240
 playlist | 18
 playlist_track | 8715

--------------------------------------

 Ended at 2022-05-26 14:23:16.373602+08

 It took 00:00:00.458396
```

</details>

------

#### Install in sqlite

Execute in command line terminal

    sqlite3 chinook.sqlite < import-sqlite.sql

If you are already at the sqlite3 prompt

    ➜ sqlite3 chinook.sqlite
    SQLite version 3.37.0 2021-12-09 01:34:53
    Enter ".help" for usage hints.
    sqlite > .read import-sqlite.sql


If the *chinook.sqlite* file does not exist, sqlite3 will automatically create it.

<details>
  <summary>Results</summary>

```
~/youwu.today/sqllab/sample/db-sample-schemas/chinook git:(develop)
➜ sqlite3 chinook.sqlite < import-sqlite.sql
start at :2022-05-26 06:20:39

CREATING DATABASE STRUCTURE
===========================================

* Dropping everything
* Creating tables
* Creating views

LOADING Data
===========================================

* LOADING artist
* LOADING album
* LOADING employee
* LOADING customer
* LOADING genre
* LOADING invoice
* LOADING media_type
* LOADING track
* LOADING invoice_line
* LOADING playlist
* LOADING playlist_trac

Counting tables record
===========================================

| tab | rows_count |
|----------------|------------|
| artist | 275 |
| album | 347 |
| employee | 8 |
| customer | 59 |
| genre | 25 |
| invoice | 412 |
| media_type | 5 |
| track | 3503 |
| invoice_line | 2240 |
| playlist | 18 |
| playlist_track | 8715 |

--------------------------------------

Ended at 2022-05-26 06:20:39

It took 00:00.000
```
</details>

----

#### install in mysql service

First, start your mysql database service instance

    mysqld --datadir=mysql database data directory

Execute in another command line terminal

    mysql --user=root --force -sN < import-mysql.sql

If you have logged in under mysql cli, you can do this
  
    ➜ mysql --user=root -sN
    mysql>\.import-mysql.sql
    or
    mysql> source import-mysql.sql



<details>
  <summary>
    result
  </summary>
  
```
➜ mysql --user=root --force -sN < import-mysql.sql
start at 2022-05-26 14:21:46

CREATING DATABASE STRUCTURE
===========================================

* Dropping everything
* Creating tables
* Creating views

LOADING DATA
===========================================

* LOADING artist
* LOADING album
* LOADING employee
* LOADING customer
* LOADING genre
* LOADING invoice
* LOADING media_type
* LOADING track
* LOADING invoice_line
* LOADING playlist
* LOADING playlist_trac

Counting tables record
===========================================

artist 275
album 347
employee 8
customer 59
genre 25
invoice 412
media_type 5
track 3503
invoice_line 2240
playlist 18
playlist_track 8715

--------------------------------------

Ended at 2022-05-26 14:21:52
It took 00:00:06.000000
```

</details>

---

### Disclaimer

> Media related data was created using real data from an iTunes Library

The original sample database for listening to music is extracted from iTunes music. The names of the representative customers and employees are fabricated, and it does not correspond to anyone in the real world. Any similarity is purely coincidental.

### Licensing


The author of the original chinook sample database allows others to use the content under this project. For specific authorization, see https://github.com/lerocha/chinook-database/blob/master/LICENSE.md .


This work is licensed under the [Attribution-ShareAlike 3.0 Unlocalized Version (CC BY-SA 3.0)][cc-by-sa] license.
To view a copy of this license, please visit
https://creativecommons.org/licenses/by-sa/3.0/deed.en.

[![CC BY-SA 3.0][cc-by-sa-image]][cc-by-sa]


<!-- reference links -->

[chinook er]: ./images/er-chinook-en.png
[chinook sample database]: https://github.com/lerocha/chinook-database
[lab]: https://youwu.today/skill/thinkinsql/how-to-setup-a-database-for-sql-learning/
[cc-by-sa]: https://creativecommons.org/licenses/by-sa/3.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/3.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%203.0-lightgrey.svg