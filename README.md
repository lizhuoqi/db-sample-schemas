![说明-中文版本](./README_zh.md)

# db sample schemas

db sample schemas, collects some popular sample databases for Postgres, MySQL, Sqlite3. Each sample database in the collection can be used to create tables, views, and load sample data into the database using a single SQL script, suitable for demonstrations, testing, learning database features, learning SQL, and more.

## Why this project was created

I have been working in the field of data development for a long time. At work, some colleagues with less work experience need to be trained on data development practices. Almost all database environments that can be used for teaching are customer development and testing environments, which are not conducive to work. In order to facilitate the demonstration, some open source, free and easy-to-deploy database products are selected to build an environment for learning and demonstration. At the same time, it also provides opportunities for them to do it themselves.

Also, there are several very popular sample databases on github with very different purposes and additional database-specific features, which even contain business logic (like oracle's [db-sample-schemas][oracle sample schemas] , is too complicated, and in order to demonstrate the functions of the oracle database when building applications, it binds many built-in packages of the oracle database dbms_*), which is easy to confuse for learning database table model design and data manipulation. Therefore, after some subjective selection, several available samples were selected and tried to generalize (DDL) these sample databases so that they can be used in Postgres, MySQL, Sqlite3, etc. environments.

Some examples are derived from MySQL or postgres. In order to make SQL as general as possible, some compromises and modifications will be made.

## Currently supported database servers

* MySQL
* SQLite
* PostgreSQL

> Why not Oracle, SQL Server, DB2? 🤔
> 
> Because the current main purpose of this project is to teach, for example, how to write SQL in the database, develop views, functions, etc., to train the thinking of data development. In practical work, the deployment of databases is usually undertaken by specialized personnel, and there are personnel or teams specialized in IT environment deployment. Deployment skills are not the purpose of this project. For those who do not usually install and deploy, the operation is too difficult, and it will take up more resources when running on a personal desktop notebook.
>
> Perhaps in future versions, the corresponding versions of these commercial database services will be provided.
> However, due to the implementation of the SQL standard, and the sample data exists in the form of csv, if you feel that the sample library is helpful to you and your team, you can migrate it yourself. Tables and views have DDL, and all databases have corresponding Loading tool for csv data files.

## Sample databases in the project

In this project, each individual sample database is managed in a separate directory.

| sample repository | size | postgres | sqlite | MySQL | source
|-------------------|------|----------|--------|-------|-------
| employees         | about 160M | ✔ | ✔ | ✔ | [MySQL Employees Sample Database][mysql sample employees]

## How to use the sample database

Each sample database is independent. When using the sample repositories, just follow the instructions in the individual sample repositories.


## How to load data

Some sample databases, because of the large number of data records, tend to use the commands supported by each database to load csv data files from local, rather than using `insert ... values()` . Therefore, when this happens, SQL scripts can only be executed on the db cli console, and most GUI clients do not recognize these built-in commands.

| Database | Data Load Commands
|----------|------------
| postgres | `\copy TABLE_NAME from CSV_FILE delimiter ',' csv header;`
| sqlite   | `.import --csv --skip 1 CSV_FILE file TABLE_NAME`
| mysql    | `\!mysqlimport --user=root --local --delete --fields-enclosed-by='"' --lines-terminated-by='\n' --fields-terminated-by=', ' --ignore-lines=1 DATABASE_NAME TABLE_NAME.csv`

> Security improvements in mysql 8 impose restrictions on command operations. At the mysql cli prompt, use `load data locale infile into table...` , the server and client must have relevant directory permissions and set server parameters, which increases the configuration steps. To reduce this complexity, when loading the mysql sample data in this project, use the mysqlimport command, which corresponds to `load data infile`.

## License Statement

The table model design and sample data in all sample databases are not original. Since the sample databases in each directory come from different independent projects, and their respective licenses are not the same, this project will license each independent sample database separately to avoid this project infringing on the rights of the original author.

---
[mysql sample employees]: https://github.com/datacharmer/test_db
[oracle sample schemas]: https://github.com/oracle-samples/db-sample-schemas
