## sakila

### 数据模型

这是一个 DVD 租赁的例子。它包含的表有影片、演员、库存、门店、出租、支付等表。

![表数据模型][sakila er]

关于原版模型设计的说明（英文），可见 [Structure][sakila structure]

### sakila 中的表

|  表名                 | 注释         | 数据（行）
|----------------------|--------------|-------
| actor    | 演员    | 200
| address  | 地址    | 603
| category | 类别    | 16
| city     | 城市    | 600
| country  | 国家    | 109
| customer | 顾客    | 599
| film     | 电影    | 1000
| film_actor    | 电影演员 | 5462
| film_category | 电影类别 | 1000
| film_text     | 电影文本 | 1000
| inventory     | 存库    | 4581
| language      | 语言    | 6
| payment       | 支付    | 16049
| rental        | 出租    | 16044
| staff         | 职员    | 2
| store         | 门店    | 2

### 视图

| 视图名               |  注释
| --------------------|--------
| v_customer_list               |
| v_film_list                   |
| v_nicer_but_slower_film_list  |
| v_staff_list                  |     
| v_sales_by_store              |
| v_sales_by_film_category      |
| v_actor_info                  |

### 过程

名称                       | postgres   | mysql      | sqlite3
---------------------------|------------|------------|---------
get_customer_balance       | fucntion   | fucntion   |不支持
inventory_held_by_customer | fucntion   | fucntion   |不支持
inventory_in_stock         | fucntion   | fucntion   |不支持
rewards_report             | fucntion   | procedure  |不支持
film_in_stock              | procedure  | procedure  |不支持
film_not_in_stock          | procedure  | procedure  |不支持


### 它来自哪里

sakila 示例数据库来自于 [Sakila Sample Database Version 1.2][sakila sample database]，它的代码 [sakila-db.zip][sakila sample database source] 。

> The Sakila sample database was initially developed by Mike Hillyer, a former member of the MySQL AB documentation team. It is intended to provide a standard schema that can be used for examples in books, tutorials, articles, samples, and so forth. The Sakila sample database also serves to highlight features of MySQL such as Views, Stored Procedures, and Triggers.
> 
> Additional information on the Sakila sample database and its usage can be found through the MySQL forums.
> 
> -- [Introduction][introduction]


### 与原版之间的差别

* *sakila-schema.sql* 中全部 16 张表保留
* 字段数据类型调整，使得 postgres、sqlite3、mysql 中均可使用
* *sakila-data.sql* 的全部数据
* 数据已按随机方式重新排序
* 暂未创建视图与函数

### 为了 postgres、sqlite3、mysql 兼容所做的调整


| 序号 | 原脚本                         | postgres  | sqlite3 | mysql
|-----|-------------------------------|-----------|---------|------
| 1   | smallint, tinyint             | int2      | int2    | int2
| 2   | mediumint                     | int       | int     | int
| 3   | UNSIGNED                      | 去掉该关键字|去掉该关键字| 去掉该关键字
| 4   | auto_increment                | sequence  | 无       | auto_increment
| 5   | 可空字段的 default null         | 去掉      | 去掉      | 去掉
| 6   | film.rating enum              | `varchar` + `check(rating in ('G','PG','PG-13','R','NC-17')) `                 | 同 postgres | 同 postgres
| 7   | film.release_year year        | `int2` + `check(release_year >= 1901 and release_year <= 2155 )`                  | 同 postgres | 同 postgres
| 8   | film.special_features set     | varchar   | varchar  | set
| 9   | staff.picture blob            | bytea     | blob     | blob
| 10  | language.name char(20)        | varchar(20) | varchar(20) | varchar(20)
| 11  | address.location GEOMETRY srid| to be done | to be done | to be done
| 12  | 每个表中的 last_update, ON UPDATE CURRENT_TIMESTAMP | to be done | to be done | to be done
| 13  | film_text 全文搜索             | to be done | to be done | to be done

<!-- todo timestamp with timezone -->

### 前提条件

准备一个 postgres、sqlite、MySQL 数据库服务。如何安装数据库服务，可看 [《如何快速设立一个可用的SQL环境》][lab]

除 sqlite 外，使用 postgres、MySQL 的，至少需要这些权限。

    SELECT, INSERT, UPDATE, DELETE, 
    CREATE, DROP, RELOAD, REFERENCES, 
    INDEX, ALTER, SHOW DATABASES, 
    CREATE TEMPORARY TABLES, 
    LOCK TABLES, EXECUTE, CREATE VIEW

一般地，若使用本地主机进行实验，我们使用的都是权限很高的用户，这些权限不需要你去特别的关心。

安装 postgres、mysql 数据库后，将这些数据库程序的 *bin* 目录配置到环境的 `PATH` 中。
sqlite 仅为一个可执行文件，可放在环境变量 `PATH` 包含的任何目录下。

### 安装示例数据库

1. 下载本存储库

2. 在命令行中进入存储库目录

```
cd PATH_TO_DB_SAMPLE_SCHEMAS/sakila
```

3. 解压 csv 数据文件

```  
unzip ./data/data.zip
```

4. 按照实际使用的数据库服务执行 SQL 脚本来创建表、导入示例数据

为了确保 SQL脚本 可以重复执行，SQL 脚本中在执行 `create` 操作前包含了视图、表的 `DROP` 操作 DDL，请忽略命令行终端如下这类错误提示信息。它只是在告诉你， “删除不存在对象” 。

    类似于 “ERROR: Table 'sakila.store' doesn't exist” 

在我个人的笔记本电脑，脚本的执行在3秒钟以内完成。

    MacBook Pro (13-inch, 2017, Two Thunderbolt 3 ports
    处理器 2.3 GHz 双核Intel Core i5
    内存 8 GB 2133 MHz LPDDR3

#### 在 Postgres 服务中安装


首先，启动你的 postgres 数据库服务实例
    
    pg_ctl -D [你的postgres示例已经初始化了的目录] start

在另一个命令行终端上执行

    psql < import-pg.sql

若已登录到 psql cli 下
  
    ➜  psql
    psql (14.2)
    Type "help" for help.
    
    macbook=#\i import-pg.sql

<details>
  <summary>结果</summary>

  命令行终端执行脚本时打印的信息过长，下面使用 `... 🥱 ...` 替代部分重复信息。
    
    ```
    ~/youwu.today/sqllab/sample/db-sample-schemas/sakila git:(develop)
    ➜  psql < import-pg.sql
    ERROR:  database "sakila" is being accessed by other users
    DETAIL:  There are 2 other sessions using the database.
    ERROR:  database "sakila" already exists
    You are now connected to database "sakila" as user "macbook".
    
     start at 2022-05-24 00:01:50.759986+08 
    
    CREATING DATABASE STRUCTURE
    ========================================
    
    - Dropping everything
    
    ... 🥱 ...
    
    - Patching
    psql:./sql/pre-pg.sql:2: ERROR:  type "datetime" already exists
    - Creating tables
    
    ... 🥱 ...
    
    - Creating views
    
     LOADING Data
    ========================================
    
    - LOADING actorCOPY 200
    - LOADING categoryCOPY 16
    - LOADING languageCOPY 6
    - LOADING filmCOPY 1000
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
    ========================================
    
    CREATE SEQUENCE
    
    ... 🥱 ...
    
    COMMENT
    
    Counting tables record
    ========================================
    
     actor         |   200
     address       |   603
     category      |    16
     city          |   600
     country       |   109
     customer      |   599
     film          |  1000
     film_actor    |  5462
     film_category |  1000
     film_text     |  1000
     inventory     |  4581
     language      |     6
     payment       | 16049
     rental        | 16044
     staff         |     2
     store         |     2
    
    --------------------------------------
    
     Ended at 2022-05-24 00:01:52.074261+08
    
     It tooks 00:00:01.31452
    ```

</details>


#### 在 sqlite 中安装

在命令行终端执行

    sqlite3 sakila.sqlite < import-sqlite.sql

若你已经在 sqlite3 的提示符下

    ➜ sqlite3 sakila.sqlite
    SQLite version 3.37.0 2021-12-09 01:34:53
    Enter ".help" for usage hints.
    sqlite> .read import-sqlite.sql


如果 *sakila.sqlite*  文件不存在，sqlite3 会自动创建。

<details>
  <summary>结果</summary>

  ```
    start at :2022-05-23 16:58:14

    CREATING DATABASE STRUCTURE
    ========================================

    Error: near line 26: in prepare, near "constraint": syntax error (1)
    * Creating tables
    * Creating views
    * LOADING actor
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
    ========================================

    |      tab      | rows_count |
    |---------------|------------|
    | actor         | 200        |
    | address       | 603        |
    | category      | 16         |
    | city          | 600        |
    | country       | 109        |
    | customer      | 599        |
    | film          | 1000       |
    | film_actor    | 5462       |
    | film_category | 1000       |
    | film_text     | 1000       |
    | inventory     | 4581       |
    | language      | 6          |
    | payment       | 16049      |
    | rental        | 16044      |
    | staff         | 2          |
    | store         | 2          |

    --------------------------------------

    Ended at 2022-05-23 16:58:14

    It tooks 00:00.000
  ```
</details>


#### 在 mysql 服务中安装

首先，启动你的 mysql 数据库服务实例

    mysqld --datadir=mysql数据库数据目录

在另一个命令行终端执行

    mysql --user=root --force -sN < import-mysql.sql

若已登录到 mysql cli 下的，可以这样
  
    ➜  mysql --user=root -sN
    mysql>\. import-mysql.sql
    或者
    mysql> source import-mysql.sql



<details>
  <summary>
    结果
  </summary>
  
  ```
    ➜  mysql --user=root --force -sN < import-mysql.sql
    start at 2022-05-24 01:23:36

    CREATING DATABASE STRUCTURE
    ========================================

    * Dropping everything
    * Creating tables
    * Creating views

    LOADING DATA
    ========================================

    sakila1.actor: Records: 200  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.category: Records: 16  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.language: Records: 6  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.film: Records: 1000  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.film_actor: Records: 5462  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.film_category: Records: 1000  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.film_text: Records: 1000  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.country: Records: 109  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.city: Records: 600  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.address: Records: 603  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.store: Records: 2  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.customer: Records: 599  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.inventory: Records: 4581  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.rental: Records: 16044  Deleted: 0  Skipped: 0  Warnings: 0
    sakila1.payment: Records: 16049  Deleted: 0  Skipped: 0  Warnings: 0

    Post Install After Data Loaded
    ========================================


    Counting tables record
    ========================================

    actor   200
    address 603
    category    16
    city    600
    country 109
    customer    599
    film    1000
    film_actor  5462
    film_category   1000
    film_text   1000
    inventory   4581
    language    6
    payment 16049
    rental  16044
    staff   2
    store   2

    --------------------------------------

    Ended at 2022-05-24 01:23:38
    It tooks 00:00:02.000000
  ```

</details>

### 免责声明

示例中的数据是捏造的，它不对应于真实世界的任何人。如有类同，纯属巧合。

### 许可授权


原 sakila 示例数据库中 *sakila-schema.sql*、*sakila-data.sql* 的内容以 [the New BSD license][bsd] 授权，具体看，https://dev.mysql.com/doc/sakila/en/sakila-license.html。

本项工作按照原示例数据库的许可进行授权。

关于 *the New BSD license*，更多内容看 [www.opensource.org/licenses/bsd-license.php][bsd]


<!-- reference links -->

[sakila er]: ./images/er-sakila.png
[sakila er en]:https://dev.mysql.com/doc/sakila/en/images/sakila-schema.png
[sakila structure]: https://dev.mysql.com/doc/sakila/en/sakila-structure.html

[sakila sample database]: https://dev.mysql.com/doc/sakila/en/
[sakila sample database source]: https://downloads.mysql.com/docs/sakila-db.zip
[introduction]: https://dev.mysql.com/doc/sakila/en/sakila-introduction.html

[lab]: https://youwu.today/skill/thinkinsql/how-to-setup-a-database-for-sql-learning/
[bsd]: http://www.opensource.org/licenses/bsd-license.php
