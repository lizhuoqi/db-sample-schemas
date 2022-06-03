## sakila

### Data Model

This is an example of DVD rental. It contains tables such as Movies, Actors, Inventory, Stores, Rentals, Payments, etc.

![table data model][sakila er en]

Instructions for the original model design (in English), see [Structure][sakila structure]

### Tables in sakila

| table name | comments | data (rows)
|------------|---------------|-------
| actor | actor | 200
| address | address | 603
| category | category | 16
| city | city | 600
| country | country | 109
| customer | customer | 599
| film | film | 1000
| film_actor | Film Actor | 5462
| film_category | Film Category | 1000
| film_text | film text | 1000
| inventory | Inventory | 4581
| language | Language | 6
| payment | Payment | 16049
| rental | Rental | 16044
| staff | staff | 2
| store | Store | 2

### views in sakila

| view name               | comments
| ------------------------|--------
| v_customer_list               |
| v_film_list                   |
| v_nicer_but_slower_film_list  |
| v_staff_list                  |     
| v_sales_by_store              |
| v_sales_by_film_category      |
| v_actor_info                  |

### routines

name                       | postgres   | mysql      | sqlite3
---------------------------|------------|------------|---------
get_customer_balance       | fucntion   | fucntion   | not supported
inventory_held_by_customer | fucntion   | fucntion   | not supported
inventory_in_stock         | fucntion   | fucntion   | not supported
rewards_report             | fucntion   | procedure  | not supported
film_in_stock              | procedure  | procedure  | not supported
film_not_in_stock          | procedure  | procedure  | not supported

### where does it come from

The sakila sample database is from [Sakila Sample Database Version 1.2][sakila sample database], its code [sakila-db.zip][sakila sample database source] .

> The Sakila sample database was initially developed by Mike Hillyer, a former member of the MySQL AB documentation team. It is intended to provide a standard schema that can be used for examples in books, tutorials, articles, samples, and so forth. The The Sakila sample database also serves to highlight features of MySQL such as Views, Stored Procedures, and Triggers.
>
> Additional information on the Sakila sample database and its usage can be found through the MySQL forums.
>
> -- [Introduction][introduction]


### Differences from the original

* All 16 tables in sakila-schema.sql* are reserved
* Field data type adjustment, so that it can be used in postgres, sqlite3, mysql
* All data for sakila-data.sql*
* Data has been reordered randomly
* Views and functions have not been created yet

### Adjustments for postgres, sqlite3, mysql compatibility


| serial number | original script | postgres | sqlite3 | mysql
|-----|-------------------------------|------------ |---------|------
| 1 | smallint, tinyint | int2 | int2 | int2
| 2 | mediumint | int | int | int
| 3 | UNSIGNED | remove this keyword | remove this keyword | remove this keyword
| 4 | auto_increment | sequence | none | auto_increment
| 5 | default null for nullable fields | remove | remove | remove
| 6 | film.rating enum | `varchar` + `check(rating in ('G','PG','PG-13','R','NC-17')) ` | same as postgres | same as postgres
| 7 | film.release_year year | `int2` + `check(release_year >= 1901 and release_year <= 2155 )` | same as postgres | same as postgres
| 8 | film.special_features set | varchar | varchar | set
| 9 | staff.picture blob | bytea | blob | blob
| 10 | language.name char(20) | varchar(20) | varchar(20) | varchar(20)
| 11 | address.location GEOMETRY srid| to be done | to be done | to be done
| 12 | last_update, ON UPDATE CURRENT_TIMESTAMP in each table | to be done | to be done | to be done
| 13 | film_text Full Text Search | to be done | to be done | to be done

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
cd PATH_TO_DB_SAMPLE_SCHEMAS/sakila
````

3. Unzip the csv data file

````
unzip ./data/data.zip
````

4. Execute the SQL script according to the actual database service used to create tables and import sample data

In order to ensure that the SQL script can be executed repeatedly, the SQL script contains the `DROP` operation DDL of the view and table before executing the `create` operation. Please ignore the following error messages in the command line terminal. It's just telling you, "delete non-existent objects".

    Similar to "ERROR: Table 'sakila.store' doesn't exist"

On my personal laptop, the execution of the script completes in under 3 seconds.

    MacBook Pro (13-inch, 2017, Two Thunderbolt 3 ports
    Processor 2.3 GHz Dual Core Intel Core i5
    Memory 8 GB 2133 MHz LPDDR3

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

  The information printed by the command line terminal when executing the script is too long. The following uses `... 🥱 ...` to replace some repeated information.
    
    ````
    ~/youwu.today/sqllab/sample/db-sample-schemas/sakila git:(develop)
    ➜ psql < import-pg.sql
    ERROR: database "sakila" is being accessed by other users
    DETAIL: There are 2 other sessions using the database.
    ERROR: database "sakila" already exists
    You are now connected to database "sakila" as user "macbook".
    
     start at 2022-05-24 00:01:50.759986+08
    
    CREATING DATABASE STRUCTURE
    ===========================================
    
    - Dropping everything
    
    ... 🥱 ...
    
    - Patching
    psql:./sql/pre-pg.sql:2: ERROR: type "datetime" already exists
    - Creating tables
    
    ... 🥱 ...
    
    - Creating views
    
     LOADING Data
    ===========================================
    
    - LOADING actorCOPY 200
    - LOADING categoryCOPY 16
    - LOADING languageCOPY 6
    -LOADING filmCOPY 1000
    - LOADING film_actorCOPY 5462
    - LOADING film_categoryCOPY 1000
    - LOADING film_textCOPY 1000
    - LOADING countryCOPY 109
    - LOADING cityCOPY 600
    - LOADING addressCOPY 603
    - LOADING storeCOPY 2
    - LOADING customerCOPY 599
    - LOADING staff
    INSERT 0 1
    INSERT 0 1
    - LOADING inventoryCOPY 4581
    - LOADING rentalCOPY 16044
    - LOADING paymentCOPY 16049
    
    Post Install After Data Loaded
    ===========================================
    
    CREATE SEQUENCE
    
    ... 🥱 ...
    
    COMMENT
    
    Counting tables record
    ===========================================
    
     actor | 200
     address | 603
     category | 16
     city ​​| 600
     country | 109
     customer | 599
     film | 1000
     film_actor | 5462
     film_category | 1000
     film_text | 1000
     inventory | 4581
     language | 6
     payment | 16049
     rental | 16044
     staff | 2
     store | 2
    
    --------------------------------------
    
     Ended at 2022-05-24 00:01:52.074261+08
    
     It took 00:00:01.31452
    ````

</details>


#### Install in sqlite

Execute in command line terminal

    sqlite3 sakila.sqlite < import-sqlite.sql

If you are already at the sqlite3 prompt

    ➜ sqlite3 sakila.sqlite
    SQLite version 3.37.0 2021-12-09 01:34:53
    Enter ".help" for usage hints.
    sqlite > .read import-sqlite.sql


If the *sakila.sqlite* file does not exist, sqlite3 will automatically create it.

<details>
  <summary>Results</summary>

  ````
    start at :2022-05-23 16:58:14

    CREATING DATABASE STRUCTURE
    ===========================================

    Error: near line 26: in prepare, near "constraint": syntax error (1)
    * Creating tables
    * Creating views
    * LOADING actors
    * LOADING category
    * LOADING language
    * LOADING film
    * LOADING film_actor
    * LOADING film_category
    * LOADING film_text
    * LOADING country
    * LOADING city
    * LOADING address
    * LOADING store
    * LOADING customer
    * LOADING staff
    * LOADING inventory
    * LOADING rental
    * LOADING payment

    Counting tables record
    ===========================================

    | tab | rows_count |
    |---------------|------------|
    | actor | 200 |
    | address | 603 |
    | category | 16 |
    | city | 600 |
    | country | 109 |
    | customer | 599 |
    | film | 1000 |
    | film_actor | 5462 |
    | film_category | 1000 |
    | film_text | 1000 |
    | inventory | 4581 |
    | language | 6 |
    | payment | 16049 |
    | rental | 16044 |
    | staff | 2 |
    | store | 2 |

    --------------------------------------

    Ended at 2022-05-23 16:58:14

    It took 00:00.000
  ````
</details>


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
  
  ````
    ➜ mysql --user=root --force -sN < import-mysql.sql
    start at 2022-05-24 01:23:36

    CREATING DATABASE STRUCTURE
    ===========================================

    * Dropping everything
    * Creating tables
    * Creating views

    LOADING DATA
    ===========================================

    sakila1.actor: Records: 200 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.category: Records: 16 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.language: Records: 6 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.film: Records: 1000 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.film_actor: Records: 5462 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.film_category: Records: 1000 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.film_text: Records: 1000 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.country: Records: 109 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.city: Records: 600 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.address: Records: 603 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.store: Records: 2 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.customer: Records: 599 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.inventory: Records: 4581 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.rental: Records: 16044 Deleted: 0 Skipped: 0 Warnings: 0
    sakila1.payment: Records: 16049 Deleted: 0 Skipped: 0 Warnings: 0

    Post Install After Data Loaded
    ===========================================


    Counting tables record
    ===========================================

    actor 200
    address 603
    category 16
    city ​​600
    country 109
    customer 599
    film 1000
    film_actor 5462
    film_category 1000
    film_text 1000
    inventory 4581
    language 6
    payment 16049
    rental 16044
    staff 2
    store 2

    --------------------------------------

    Ended at 2022-05-24 01:23:38
    It took 00:00:02.000000
  ````

</details>

### DISCLAIMER

The data in the example is fabricated and it does not correspond to anyone in the real world. Any similarity is purely coincidental.

### Licensing


The contents of *sakila-schema.sql* and *sakila-data.sql* in the original sakila sample database are authorized by [the New BSD license][bsd]. For details, see https://dev.mysql.com/doc/sakila /en/sakila-license.html.

This work is licensed under the license of the original sample database.

For *the New BSD license*, see [www.opensource.org/licenses/bsd-license.php][bsd]


<!-- reference links -->

[sakila er]: ./images/er-sakila.png
[sakila er en]:https://dev.mysql.com/doc/sakila/en/images/sakila-schema.png
[sakila er structure]: https://dev.mysql.com/doc/sakila/en/sakila-structure.html

[sakila sample database]: https://dev.mysql.com/doc/sakila/en/
[sakila sample database source]: https://downloads.mysql.com/docs/sakila-db.zip
[introduction]: https://dev.mysql.com/doc/sakila/en/sakila-introduction.html

[lab]: https://youwu.today/skill/thinkinsql/how-to-setup-a-database-for-sql-learning/
[bsd]: http://www.opensource.org/licenses/bsd-license.php