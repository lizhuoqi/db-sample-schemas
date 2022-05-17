# db sample schemas

db sample schemas，收集一些热门的示例数据库，可用于 Postgres、MySQL、Sqlite3。收藏集中的每个示例数据库，可以通过使用单个 SQL 脚本来创建表、视图，并将示例数据装到数据库中，适用于演示、测试、学习数据库功能、学习 SQL 等。

## 为什么创建本项目

本人很长时间都在从事数据开发领域的工作。懵懵懂懂、跌跌撞撞，积累了一些经验。在工作中，需要给一些工作经验较浅的同事对数据开发实践进行相关的培训，几乎所有可用于教学的数据库环境都是客户开发、测试环境，不利于工作开展。为了更方便演示，选择了一些开源免费、方便部署的数据库产品来构建学习、演示的环境。同时，也为他们自己动手提供机会。

另外，github 上有几个非常流行的示例数据库，它们有非常不同的目的，以及附加了特定数据库功能，其中甚至还包含了业务逻辑（如 oracle 的 [db-sample-schemas][oracle sample schemas]，太过复杂，并为了演示 oracle 数据库在构建应用时的功能，绑定了 oracle 数据库很多内置的包 dbms_*），对于学习数据库表模型设计、数据操作来说，很容易混淆。因此，在经过一定主观挑选后，选择了几个可用示例，并尝试将这些示例数据库通用化（DDL），让它们可以被使用到 Postgres、MySQL、Sqlite3 等环境中。

也因此，有些示例是源于 MySQL 或者 postgres，为了能 SQL 尽可能的通用化，会做一些折衷、变通。

## 当前支持的数据库服务器

* MySQL
* SQLite
* PostgreSQL

> 为什么没有 Oracle、SQL Server、DB2 这些呢？🤔 
> 
> 因本项目当前的主要目的是教学，比如，如何在数据库编写 SQL ，开发视图、函数等，以训练数据开发的思维。在实际工作中，数据库的部署，通常由专门的人员负责，并且有专门从事IT环境部署的人员或团队。部署技能不是本项目的目的，对于平常不搞安装部署的人来说，操作难度太大，并且运行在个人桌面笔记本时会占用较多资源。
> 
> 也许在未来的版本中，将会提供的这些商业数据库服务对应的版本。
> 不过，由于 SQL 标准的实施，并且示例数据以 csv 形式存在，若感觉示例库对你及你的团队有帮助，可以自已迁移，表、视图均有DDL，且所有的数据库均有对应的 csv 数据文件的加载工具。

## 项目中的示例数据库

本项目中，每一个独立示例数据库均以一个单独的目录管理。

示例库      | 大小 | postgres | sqlite | MySQL | 来源
-----------|----------|--------|-------|--------
employees  | 约160M | ✔ | ✔ | ✔ | [MySQL Employees Sample Database][mysql sample employees] 

## 如何使用示例数据库

每个示例数据库都是独立的。使用示例库时，按照各个示例数据库中的说明操作即可。


## 数据加载的方式

部分示例数据库，因为数据记录比较多，倾向于使用了各个数据库所支持的从本地装载 csv 数据文件的命令，而不是使用 `insert ... values()` 。因此，出现这种情况的时候，SQL 脚本只能在命令行终端上执行，大部分 GUI 客户端无法识别这些内置的命令。

数据库    |   数据装载命令
---------|------------
postgres |  `\copy 表名 from csv文件 delimiter ',' csv header;`
sqlite   | `.import --csv --skip 1  csv数据文件 表名`
mysql    | `\! mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=',' --ignore-lines=1 数据库名称 表对应的csv数据文件`

> mysql 8 中的安全性提高，对命令操作加了限制。在 mysql cli 提示符下，使用 `load data locale infile into table...` ，必须要服务器、客户端有相关的目录权限与设置服务器参数，这增加了配置步骤。为了减少这个复杂性，本项目中在装载 mysql 示例数据时，使用 mysqlimport 命令，它与 `load data infile` 是对应的。

<!-- todo, 说明如何准备 postgres、sqlite、mysql服务环境 -->
## 许可声明

所有示例数据库中的表模型设计、示例数据均非原创。由于各目录下的示例数据库来自于不同的独立项目，它们各自的许可也不尽相同，故本项目将对每个独立示例数据库进行单独的许可，以避免本项目侵犯了原作者的权利。

---
[mysql sample employees]:https://github.com/datacharmer/test_db
[oracle sample schemas]: https://github.com/oracle-samples/db-sample-schemas