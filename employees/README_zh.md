## employees

### 数据模型

这是一个以雇员为例子的示例数据库。它包含的表有部门、员工、员工所属部门、员工职位、员工薪酬等。

![表数据模型][er employees]

关于原版模型设计的说明（英文），可见 [Employees Structure][er employees structure]

### employees 中的表

|  表名                 | 注释         | 数据（行）
|----------------------|--------------|-------
| departments          | 部门          | 9
| dept_emp             | 员工所属部门    | 331603
| dept_manager         | 部门主管       | 24
| employees            | 员工          | 300024
| salaries             | 员工薪酬       | 2844047
| titles               | 员工岗位       | 443308

### 视图

| 视图名               | 作用
| --------------------|--------
| v_emp_latest_date   | 查询员工最后状态的日期，包括在职或者离职
| v_current_dept_emp  | 根据员工最后状态查询部门员工

### 它来自哪里

原数据库来自于 [Employees Sample Database][mysql sample employees]，它的代码在 [test_db][mysql sample employees codebase] 公开。

> The original data was created by Fusheng Wang and Carlo Zaniolo at Siemens Corporate Research. The data is in XML format. http://timecenter.cs.aau.dk/software.htm
>
> Giuseppe Maxia made the relational schema and Patrick Crews exported the data in relational format.
> 
> The database contains about 300,000 employee records with 2.8 million salary entries. The export data is 167 MB, which is not huge, but heavy enough to be non-trivial for testing.
> 
>   ```该数据库包含约 300,000 条员工记录，其中 280 万条工资条目。 导出的数据是167MB，不算大，但是重到足以进行测试。```
> 
> 
> The data was generated, and as such there are inconsistencies and subtle problems. Rather than removing them, we decided to leave the contents untouched, and use these issues as data cleaning exercises.
> 
> -- [where-it-comes-from][where is comes from]
>

### 与原版之间的差别

* 使用了 *employees.sql*
* 使用了 *load_\*.dump* 文件中的数据
* 数据已按随机方式重新排序
* 暂未创建 *objects.sql* 中的视图与函数
* 原代码库中 *test_\*.sh* 测试无法执行

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
cd PATH_TO_DB_SAMPLE_SCHEMAS/employees
```

3. 解压 csv 数据文件

```  
unzip ./data/data.zip
```

4. 按照实际使用的数据库服务执行 SQL 脚本来创建表、导入示例数据

为了确保 SQL脚本 可以重复执行，SQL 脚本中在执行 `create` 操作前包含了视图、表的 `DROP` 操作 DDL，请忽略命令行终端如下这类的错误提示信息，它是在告诉你， “删除不存在对象” 。

    类似于 “ERROR:  view "v_current_dept_emp" does not exist” 

在我个人的笔记本电脑，脚本的执行大约1分钟。

    MacBook Pro (13-inch, 2017, Two Thunderbolt 3 ports
    处理器 2.3 GHz 双核Intel Core i5
    内存 8 GB 2133 MHz LPDDR3

#### 在 Postgres 服务中安装


首先，启动你的 postgres 数据库服务实例
    
    pg_ctl -D [你的postgres示例已经初始化了的目录] start

在另一个命令行终端上执行

    psql < import-postgres.sql

若已登录到 psql cli 下
  
    ➜  psql
    psql (14.2)
    Type "help" for help.
    
    macbook=#\i import-postgres.sql

<details>
  <summary>结果</summary>

    ➜  psql < import-postgres.sql
    DROP DATABASE
    CREATE DATABASE
    You are now connected to database "employees" as user "macbook".
    
    start at 2022-05-17 12:43:38.591187+08
    
     CREATING DATABASE STRUCTURE
    
    psql:./sql/drop.sql:3: ERROR:  view "v_current_dept_emp" does not exist
    psql:./sql/drop.sql:4: ERROR:  view "v_emp_latest_date" does not exist
    psql:./sql/drop.sql:5: NOTICE:  table "dept_emp" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:6: NOTICE:  table "dept_manager" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:7: NOTICE:  table "titles" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:8: NOTICE:  table "salaries" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:9: NOTICE:  table "employees" does not exist, skipping
    DROP TABLE
    psql:./sql/drop.sql:10: NOTICE:  table "departments" does not exist, skipping
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
    
     It tooks 00:00:54.777496
    
    
     Counting tables record
    
     dept_emp     |     331603
     dept_manager |         24
     titles       |     443308
     salaries     |    2844047
     employees    |     300024
     departments  |          9
</details>


#### 在 sqlite 中安装

在命令行终端执行

    sqlite3 employees.sqlite < import-sqlite.sql

若你已经在 sqlite3 的提示符下

    ➜ sqlite3 employees.sqlite
    SQLite version 3.37.0 2021-12-09 01:34:53
    Enter ".help" for usage hints.
    sqlite> .read import-sqlite.sql


如果 *employees.sqlite*  文件不存在，sqlite3 会自动创建。

<details>
  <summary>结果</summary>

  ```
  CREATING DATABASE STRUCTURE
  Error: near line 3: in prepare, no such view: v_current_dept_emp (1)
  Error: near line 4: in prepare, no such view: v_emp_latest_date (1)
  LOADING departments
  LOADING employees
  LOADING titles
  LOADING dept_emp
  LOADING dept_manager
  LOADING salaries
  It tooks 00:48.000
  
  Counting tables record
  dept_emp|331603
  dept_manager|24
  titles|443308
  salaries|2844047
  employees|300024
  departments|9
  ```
</details>


#### 在 mysql 服务中安装

首先，启动你的 mysql 数据库服务实例

    mysqld --datadir=mysql数据库数据目录

在另一个命令行终端执行

    mysql --user=root --force -sN < import-postgres.sql

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
  start at 2022-05-17 11:52:50
  CREATING DATABASE STRUCTURE
  Dropping everything
  ERROR 1051 (42S02) at line 3 in file: './sql/drop.sql': Unknown table 'employees.v_current_dept_emp'
  ERROR 1051 (42S02) at line 4 in file: './sql/drop.sql': Unknown table 'employees.v_emp_latest_date'
  Creating tables
  storage engine: InnoDB
  Creating views

  LOADING departments
  employees.departments: Records: 9  Deleted: 0  Skipped: 0  Warnings: 0

  LOADING employees
  employees.employees: Records: 300024  Deleted: 0  Skipped: 0  Warnings: 0
  LOADING dept_emp
  employees.dept_emp: Records: 331603  Deleted: 0  Skipped: 0  Warnings: 0
  LOADING dept_manager
  employees.dept_manager: Records: 24  Deleted: 0  Skipped: 0  Warnings: 0
  LOADING salaries
  employees.salaries: Records: 2844047  Deleted: 0  Skipped: 0  Warnings: 0
  LOADING titles
  employees.titles: Records: 443308  Deleted: 0  Skipped: 0  Warnings: 0

  Ended at 2022-05-17 11:53:58
  It tooks 00:01:08.000000

  Counting tables record
  dept_emp  331603
  dept_manager  24
  titles  443308
  salaries  2844047
  employees 300024
  departments 9
  ```

</details>

### 免费声明

示例中的数据是捏造的，它不对应于真实世界的任何人。如有类同，纯属巧合。

### 许可授权

这项工作在 [署名-相同方式共享 3.0 未本地化版本 (CC BY-SA 3.0) ][cc-by-sa] 许可下许可。
要查看此许可证的副本，请访问
https://creativecommons.org/licenses/by-sa/3.0/deed.zh。

[![CC BY-SA 3.0][cc-by-sa-image]][cc-by-sa]

<!-- reference links -->
[lab]: https://youwu.today/skill/thinkinsql/how-to-setup-a-database-for-sql-learning/
[where is comes from]: https://github.com/datacharmer/test_db#where-it-comes-from
[mysql sample employees]: https://dev.mysql.com/doc/employee/en/
[mysql sample employees codebase]: https://github.com/datacharmer/test_db
[er employees ori]: ./images/employees-schema.png
[er employees]: ./images/er-employees-zh.png
[er employees structure]: https://dev.mysql.com/doc/employee/en/sakila-structure.html


[cc-by-sa]: https://creativecommons.org/licenses/by-sa/3.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/3.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%203.0-lightgrey.svg
