
## chinook

### 数据模型

这是一个 音乐专辑销量 的示例。它包含的表有专辑、艺术家、顾客、员工、发票等表。

![表数据模型][chinook er]


### chinook 中的表

|  表名           | 注释         | 数据（行）
|----------------|--------------|------------|
| artist         |	艺术家       | 275        |
| album          |	专辑         | 347        |
| employee       |	员工         | 8          |
| customer       |	顾客         | 59         |
| genre          |	音乐风格     |  25         |
| invoice        |	发票         | 412        |
| media_type     |	媒体文件类型  | 5          |
| track          |	曲目         | 3503       |
| invoice_line   |	发票行       | 2240       |
| playlist       |	播放列表     | 18         |
| playlist_track |	播放列表曲目  | 8715       |


### 它来自哪里

sakila 示例数据库来自于 [Chinook Database - Version 1.4][chinook sample database]。

> Chinook is a sample database available for SQL Server, Oracle, MySQL, etc. It can be created by running a single SQL script. Chinook database is an alternative to the Northwind database, being ideal for demos and testing ORM tools targeting single and multiple database servers.


### 与原版之间的差别

* *Chinook_postgres.sql* 中全部 11 张表和数据
* *employee.birth_date*、*employee.hire_date* 字段数据类型调整为 `datetime`，为个别日期超过 mysql timestamp 类型的值范围。
* 标识符统一使用小写 snake case 方式命名（使用“[]”、“\`\`”、“驼峰” 来写 sql 实在太反人类），更方便 ⌨️ 手工连续输入
* 数据已按随机方式重新排序
* 只使用了示例数据库中的 表、数据。其他 *C#* 应用程序不使用，未来也不会。

### 为了 postgres、sqlite3、mysql 兼容所做的调整


| 序号 | 原脚本                         | postgres  | sqlite3 | mysql
|-----|-------------------------------|-----------|-----------|------
| 1   | employee.birth_date timestamp | timestamp | timestamp | datetime
| 2   | employee.hire_date timestamp  | timestamp | timestamp | datetime

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
cd PATH_TO_DB_SAMPLE_SCHEMAS/chinook
```

3. 解压 csv 数据文件

```  
unzip ./data/data.zip
```

4. 按照实际使用的数据库服务执行 SQL 脚本来创建表、导入示例数据

为了确保 SQL脚本 可以重复执行，SQL 脚本中在执行 `create` 操作前包含了视图、表的 `DROP` 操作 DDL，请忽略命令行终端如下这类错误提示信息。它只是在告诉你， “删除不存在对象” 。

    类似于 “ERROR: Table 'chinook.album' doesn't exist” 

在我个人的笔记本电脑，脚本的执行在3秒钟以内完成。

    MacBook Pro (13-inch, 2017, Two Thunderbolt 3 ports
    处理器 2.3 GHz 双核Intel Core i5
    内存 8 GB 2133 MHz LPDDR3


>   命令行终端执行脚本时打印的信息过长，下面使用 `... 🥱 ...` 替代部分非关键信息。

<!-- todo 空值处理专门的文章 -->

本示例数据库提供了两种数据加载方式，使用数据库的文本文件加载工具或者 *insert ... values()* 的纯sql方式，两种方式各有优缺点。

*insert ... values()* 兼容性最好，postgres	、mysql、sqlite3 能用，但其效率比直接的文件加载的方式低。本例选择了折衷的方案：


数据库     |   加载方式      | 说明
----------|---------------|------------
postgres  |  `\copy`          | csv 文本中的空值无须特别处理，如 ",,"
mysql     |  `insert ...` sql | 默认方式
mysql     |  mysqlimport      | 因 mysqlimport 会对空值进行“零值”转换, 字符类型的字段空值变成空字符串（''），数字类型字段值置为“0”。
sqlite3   |  .import          | 默认方式，但由于空值问题，字段会被置为空字符串，`is null` 失效，而要用 `= ''`
sqlite3   |  `insert ...` sql | 效率要比 *.import* 的慢很多。

若想启动非默认方式，修改 *import-\*.sql*	脚本中的 *LOADING* 部分。

如 *import-sqlite.sql* 中，默认使用 `.import` 命令，若注释掉 `.import` 行，反注释 `.read` 行，则会使用 `insert ...` sql 加载数据。
```sql
-- .read ./data/artist.sql
.import --csv --skip 1 data/artist.csv artist
```



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

    
  ```
  ~/youwu.today/sqllab/sample/db-sample-schemas/chinook git:(develop)
  ➜  psql < import-pg.sql
  ERROR:  database "chinook" is being accessed by other users
  DETAIL:  There are 2 other sessions using the database.
  ERROR:  database "chinook" already exists
  You are now connected to database "chinook" as user "macbook".
  
  start at 2022-05-26 14:23:15.915499+08
  
  CREATING DATABASE STRUCTURE
  ========================================
  
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
  ========================================
  
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
  ========================================
  
  COMMENT
  
  ... 🥱 ...
  
  COMMENT
  
  Counting tables record
  ========================================
  
   artist         |        275
   album          |        347
   employee       |          8
   customer       |         59
   genre          |         25
   invoice        |        412
   media_type     |          5
   track          |       3503
   invoice_line   |       2240
   playlist       |         18
   playlist_track |       8715
  
  --------------------------------------
  
  Ended at 2022-05-26 14:23:16.373602+08
  
  It tooks 00:00:00.458396
  ```

</details>

------

#### 在 sqlite 中安装

在命令行终端执行

    sqlite3 chinook.sqlite < import-sqlite.sql

若你已经在 sqlite3 的提示符下

    ➜ sqlite3 chinook.sqlite
    SQLite version 3.37.0 2021-12-09 01:34:53
    Enter ".help" for usage hints.
    sqlite> .read import-sqlite.sql


如果 *chinook.sqlite*  文件不存在，sqlite3 会自动创建。

<details>
  <summary>结果</summary>

  ```
  ~/youwu.today/sqllab/sample/db-sample-schemas/chinook git:(develop)
  ➜  sqlite3 chinook.sqlite < import-sqlite.sql
  start at :2022-05-26 06:20:39
  
  CREATING DATABASE STRUCTURE
  ========================================
  
  * Dropping everything
  * Creating tables
  * Creating views
  
  LOADING Data
  ========================================
  
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
  ========================================
  
  |      tab       | rows_count |
  |----------------|------------|
  | artist         | 275        |
  | album          | 347        |
  | employee       | 8          |
  | customer       | 59         |
  | genre          | 25         |
  | invoice        | 412        |
  | media_type     | 5          |
  | track          | 3503       |
  | invoice_line   | 2240       |
  | playlist       | 18         |
  | playlist_track | 8715       |
  
  --------------------------------------
  
  Ended at 2022-05-26 06:20:39
  
  It tooks 00:00.000
  ```
</details>

----

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
  start at 2022-05-26 14:21:46
  
  CREATING DATABASE STRUCTURE
  ========================================
  
  * Dropping everything
  * Creating tables
  * Creating views
  
  LOADING DATA
  ========================================
  
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
  ========================================
  
  artist	275
  album	347
  employee	8
  customer	59
  genre	25
  invoice	412
  media_type	5
  track	3503
  invoice_line	2240
  playlist	18
  playlist_track	8715
  
  --------------------------------------
  
  Ended at 2022-05-26 14:21:52
  It tooks 00:00:06.000000
  ```

</details>

---

### 免责声明

> Media related data was created using real data from an iTunes Library

原示例数据库听音乐，是从 iTunes 的音乐中提取出来的。其中代表人的顾客、员工的姓名是捏造的，它不对应于真实世界的任何人。如有类同，纯属巧合。

### 许可授权


原 chinook 示例数据库作者允许其他人使用该项目下的内容，具体授权见 https://github.com/lerocha/chinook-database/blob/master/LICENSE.md 。


这项工作在 [署名-相同方式共享 3.0 未本地化版本 (CC BY-SA 3.0) ][cc-by-sa] 许可下许可。
要查看此许可证的副本，请访问
https://creativecommons.org/licenses/by-sa/3.0/deed.zh。

[![CC BY-SA 3.0][cc-by-sa-image]][cc-by-sa]


<!-- reference links -->

[chinook er]: ./images/er-chinook.png
[chinook sample database]: https://github.com/lerocha/chinook-database
[lab]: https://youwu.today/skill/thinkinsql/how-to-setup-a-database-for-sql-learning/
[cc-by-sa]: https://creativecommons.org/licenses/by-sa/3.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/3.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%203.0-lightgrey.svg

