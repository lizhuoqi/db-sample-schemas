-- drop everything in database 

drop view v_customer_list;
drop view v_film_list;
drop view v_nicer_but_slower_film_list;
drop view v_staff_list;
drop view v_sales_by_store;
drop view v_sales_by_film_category;
drop view v_actor_info;


-- drop table if exists actor cascade;
-- drop table if exists category cascade;
-- drop table if exists language cascade;
-- drop table if exists film cascade;
-- drop table if exists film_actor cascade;
-- drop table if exists film_category cascade;
-- drop table if exists film_text cascade;
-- drop table if exists country cascade;
-- drop table if exists city cascade;
-- drop table if exists address cascade;
-- drop table if exists store cascade;
-- drop table if exists customer cascade;
-- drop table if exists staff cascade;
-- drop table if exists inventory cascade;
-- drop table if exists rental cascade;
-- drop table if exists payment cascade;

drop table if exists payment;
drop table if exists rental;
drop table if exists inventory;
-- The table store/staff refer to each other.
-- sqlite3 cli "syntax error", mysql cli "table store not exists"
alter table store drop constraint store_manager_staff_id_fkey;
drop table if exists staff;
drop table if exists customer;
drop table if exists store;
drop table if exists address;
drop table if exists city;
drop table if exists country;
drop table if exists film_text;
drop table if exists film_category;
drop table if exists film_actor;
drop table if exists film;
drop table if exists language;
drop table if exists category;
drop table if exists actor;
