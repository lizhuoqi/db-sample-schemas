-- drop everything in database 

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
-- The table store/staff refer to each other,
-- "drop column" rather then "drop foreign key"
-- because sqlite has no "drop foreign key" clause.
alter table store drop column manager_staff_id;
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
