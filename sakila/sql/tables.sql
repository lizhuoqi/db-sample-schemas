/*
tables, created by this order, dropped reversed.
==========================

actor
category
language
film
film_actor
film_category
film_text
country
city
address
store
customer
staff
inventory
rental
payment

notes
======
Sqlite3 does not have the syntax
"alter table ... alter column ... autoincrement". 
If necessary, you can add the "autoincrement" keyword 
to the primary key field of each table whose data type is integer.
*/

--
-- Table structure for table "actor"
--

CREATE TABLE actor (
  actor_id int2 NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (actor_id)
  -- KEY idx_actor_last_name (last_name)
);


-- todo 
-- 2.last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
-- 
CREATE INDEX idx_actor_last_name ON actor (last_name);

-- ----------------------------
-- Table structure for category
-- ----------------------------

CREATE TABLE category (
  category_id int2 NOT NULL,
  name VARCHAR(25) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (category_id)
);
-- todo
-- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--
-- Table structure for table language
--

CREATE TABLE language (
  language_id int2 NOT NULL,
  name varchar(20) NOT NULL,
  -- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (language_id)
);

--
-- Table structure for table `film`
--
-- 1. about Enum, postgres `create type typename as enum(...);`
-- but not `create table tablename(col enum(...));`
-- 2. about type `YEAR`, use `int2` instead
-- 3. type `SET`.

CREATE TABLE film (
  film_id int2 NOT NULL,
  title VARCHAR(128) NOT NULL,
  description TEXT DEFAULT NULL,
  release_year int2 DEFAULT NULL,
  language_id int2 NOT NULL,
  original_language_id int2 DEFAULT NULL,
  rental_duration int2 NOT NULL DEFAULT 3,
  rental_rate DECIMAL(4,2) NOT NULL DEFAULT 4.99,
  length int2 DEFAULT NULL,
  replacement_cost DECIMAL(5,2) NOT NULL DEFAULT 19.99,
  -- rating ENUM('G','PG','PG-13','R','NC-17') DEFAULT 'G',
  rating varchar(5) DEFAULT 'G',
  -- special_features SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
  special_features varchar(100),
  -- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (film_id),
  check(rating in ('G','PG','PG-13','R','NC-17')),
  -- https://dev.mysql.com/doc/refman/8.0/en/year.html
  check(release_year >= 1901 and release_year <= 2155 ),
  CONSTRAINT film_language_id_fkey FOREIGN KEY (language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
  -- todo CONSTRAINT film_original_language_id_fkey FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- todo set, enum type, year
create index idx_title on film(title);
  -- todo，上面外键是否会自动创建索引。
-- create index idx_fk_language_id on film(language_id);
-- create index idx_fk_original_language_id on film(original_language_id);


  
-- --
-- -- Triggers for loading film_text from film
-- --

-- DELIMITER ;;
-- CREATE TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
--     INSERT INTO film_text (film_id, title, description)
--         VALUES (new.film_id, new.title, new.description);
--   END;;


-- CREATE TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
--     IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
--     THEN
--         UPDATE film_text
--             SET title=new.title,
--                 description=new.description,
--                 film_id=new.film_id
--         WHERE film_id=old.film_id;
--     END IF;
--   END;;


-- CREATE TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
--     DELETE FROM film_text WHERE film_id = old.film_id;
--   END;;

-- DELIMITER ;


--
-- Table structure for table `film_actor`
--

CREATE TABLE film_actor (
  actor_id int2 NOT NULL,
  film_id int2 NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (actor_id,film_id),
  CONSTRAINT film_actor_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT film_actor_film_id_fkey FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- create index idx_fk_film_id on film_actor(film_id);


--
-- Table structure for table film_category
--

CREATE TABLE film_category (
  film_id int2 NOT NULL,
  category_id int2 NOT NULL,
  -- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (film_id, category_id),
  CONSTRAINT film_category_film_id_fkey FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT film_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;

--
-- Table structure for table `film_text`
-- 
-- InnoDB added FULLTEXT support in 5.6.10. If you use an
-- earlier version, then consider upgrading (recommended) or 
-- changing InnoDB to MyISAM as the film_text engine
--

-- Use InnoDB for film_text as of 5.6.10, MyISAM prior to 5.6.10.
-- SET @old_default_storage_engine = @@default_storage_engine;
-- SET @@default_storage_engine = 'MyISAM';
-- /*!50610 SET @@default_storage_engine = 'InnoDB'*/;

CREATE TABLE film_text (
  film_id int2 NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  PRIMARY KEY  (film_id)
);

-- todo  FULLTEXT KEY idx_title_description (title,description)
-- SET @@default_storage_engine = @old_default_storage_engine;

--
-- Table structure for table `country`
--

CREATE TABLE country (
  country_id int2 NOT NULL,
  country VARCHAR(50) NOT NULL,
  -- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (country_id)
);

-- todo--
-- Table structure for table `city`
--

CREATE TABLE city (
  city_id int2 NOT NULL,
  city VARCHAR(50) NOT NULL,
  country_id int2 NOT NULL,
  -- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (city_id),
  CONSTRAINT city_country_id_fkey FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- todo
  -- CONSTRAINT `fk_city_country` FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE RESTRICT ON UPDATE CASCADE
  -- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  -- FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,

-- create index idx_fk_country_id on city(country_id);--
-- Table structure for table address
--

CREATE TABLE address (
  address_id int2 NOT NULL,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id int2 NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  -- Add GEOMETRY column for MySQL 5.7.5 and higher
  -- Also include SRID attribute for MySQL 8.0.3 and higher
  -- /*!50705 location GEOMETRY */ /*!80003 SRID 0 */ /*!50705 NOT NULL,*/
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (address_id),
  -- /*!50705 SPATIAL KEY `idx_location` (location),*/
  CONSTRAINT address_city_id_fkey FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- todo
  -- last_update ON UPDATE CURRENT_TIMESTAMP,

-- create index idx_fk_city_id on address(city_id);

--
-- Table structure for table store
--

CREATE TABLE store (
  store_id int2 NOT NULL,
  manager_staff_id int2 NOT NULL,
  address_id int2 NOT NULL,
  -- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (store_id),
  UNIQUE (manager_staff_id),
  -- postgres, can't REFERENCES before table `staff` created 
  -- CONSTRAINT store_manager_staff_id_fkey FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT store_address_id_fkey FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

  -- KEY idx_fk_address_id (address_id),
  -- todo uniqe with name


--
-- Table structure for table `customer`
--

CREATE TABLE customer (
  customer_id int2 NOT NULL,
  store_id int2 NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id int2 NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  create_date DATETIME NOT NULL,
  -- last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (customer_id),
  CONSTRAINT customer_address_id_fkey FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT customer_store_id_fkey FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;


-- create index idx_fk_store_id on customer(store_id);
-- create index idx_fk_address_id on customer(address_id);
create index idx_last_name on customer (last_name);
--
-- Table structure for table `staff`
--

CREATE TABLE staff (
  staff_id int2 NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id int2 NOT NULL,
  -- picture BLOB DEFAULT NULL,
  email VARCHAR(50),
  store_id int2 NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40),
  -- password VARCHAR(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (staff_id),

  CONSTRAINT staff_store_id_fkey FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT staff_address_id_fkey FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

  -- KEY idx_fk_store_id (store_id),
  -- KEY idx_fk_address_id (address_id),
--
-- Table structure for table inventory
--

CREATE TABLE inventory (
  inventory_id int NOT NULL,
  film_id int2 NOT NULL,
  store_id int2 NOT NULL,
  -- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (inventory_id),
  CONSTRAINT inventory_store_id_fkey FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT inventory_film_id_fkey FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


  -- KEY idx_fk_film_id (film_id),
  -- KEY idx_store_id_film_id (store_id,film_id),

create index idx_inventory_store_id_film_id on inventory(store_id, film_id);

-- create index idx_fk_film_id on inventory(film_id);
-- create index idx_store_id_film_id inventory(store_id);

--
-- Table structure for table `rental`
--

CREATE TABLE rental (
  rental_id INT NOT NULL,
  rental_date datetime NOT NULL,
  inventory_id INT NOT NULL,
  customer_id int2 NOT NULL,
  return_date datetime DEFAULT NULL,
  staff_id INT2 NOT NULL,
  -- last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (rental_id),
  UNIQUE  (rental_date,inventory_id,customer_id),
  CONSTRAINT rental_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT rental_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT rental_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

  -- KEY idx_fk_inventory_id (inventory_id),
  -- KEY idx_fk_customer_id (customer_id),
  -- KEY idx_fk_staff_id (staff_id),
-- create index idx_fk_inventory_id on rental(inventory_id);
-- create index idx_fk_customer_id on rental(cust_id);
-- create index idx_fk_staff_id on rental(staff_id);

--
-- Table structure for table payment
--

CREATE TABLE payment (
  payment_id int2 NOT NULL,
  customer_id int2 NOT NULL,
  staff_id int2 NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (payment_id),
  CONSTRAINT payment_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental (rental_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT payment_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT payment_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

  -- KEY idx_fk_staff_id (staff_id),
  -- KEY idx_fk_customer_id (customer_id),

