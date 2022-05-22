--
-- add sequences and set sequences nextval
-- 
-- -- create sequence
-- CREATE SEQUENCE tablename_colname_seq owned by tablename.colname;
-- -- set the current value of the sequence to the max value from that column
-- ALTER TABLE tablename ALTER COLUMN colname SET DEFAULT nextval('tablename_colname_seq');
-- -- use sequence for the target column
-- SELECT SETVAL('tablename_colname_seq', (select max(colname)+1 from tablename), false)

CREATE SEQUENCE actor_actor_id_seq owned by actor.actor_id;
CREATE SEQUENCE address_address_id_seq owned by address.address_id;
CREATE SEQUENCE category_category_id_seq owned by category.category_id;
CREATE SEQUENCE city_city_id_seq owned by city.city_id;
CREATE SEQUENCE country_country_id_seq owned by country.country_id;
CREATE SEQUENCE customer_customer_id_seq owned by customer.customer_id;
CREATE SEQUENCE film_film_id_seq owned by film.film_id;
CREATE SEQUENCE inventory_inventory_id_seq owned by inventory.inventory_id;
CREATE SEQUENCE language_language_id_seq owned by language.language_id;
CREATE SEQUENCE payment_payment_id_seq owned by payment.payment_id;
CREATE SEQUENCE rental_rental_id_seq owned by rental.rental_id;
CREATE SEQUENCE staff_staff_id_seq owned by staff.staff_id;
CREATE SEQUENCE store_store_id_seq owned by store.store_id;

ALTER TABLE actor ALTER COLUMN actor_id SET DEFAULT nextval('actor_actor_id_seq');
ALTER TABLE address ALTER COLUMN address_id SET DEFAULT nextval('address_address_id_seq');
ALTER TABLE category ALTER COLUMN category_id SET DEFAULT nextval('category_category_id_seq');
ALTER TABLE city ALTER COLUMN city_id SET DEFAULT nextval('city_city_id_seq');
ALTER TABLE country ALTER COLUMN country_id SET DEFAULT nextval('country_country_id_seq');
ALTER TABLE customer ALTER COLUMN customer_id SET DEFAULT nextval('customer_customer_id_seq');
ALTER TABLE film ALTER COLUMN film_id SET DEFAULT nextval('film_film_id_seq');
ALTER TABLE inventory ALTER COLUMN inventory_id SET DEFAULT nextval('inventory_inventory_id_seq');
ALTER TABLE language ALTER COLUMN language_id SET DEFAULT nextval('language_language_id_seq');
ALTER TABLE payment ALTER COLUMN payment_id SET DEFAULT nextval('payment_payment_id_seq');
ALTER TABLE rental ALTER COLUMN rental_id SET DEFAULT nextval('rental_rental_id_seq');
ALTER TABLE staff ALTER COLUMN staff_id SET DEFAULT nextval('staff_staff_id_seq');
ALTER TABLE store ALTER COLUMN store_id SET DEFAULT nextval('store_store_id_seq');

select 'reset seq actor_actor_id_seq', setval('actor_actor_id_seq', (select max(actor_id) + 1 from actor), false);
select 'reset seq address_address_id_seq', setval('address_address_id_seq', (select max(address_id) + 1 from address), false);
select 'reset seq category_category_id_seq', setval('category_category_id_seq', (select max(category_id) + 1 from category), false);
select 'reset seq city_city_id_seq', setval('city_city_id_seq', (select max(city_id) + 1 from city), false);
select 'reset seq country_country_id_seq', setval('country_country_id_seq', (select max(country_id) + 1 from country), false);
select 'reset seq customer_customer_id_seq', setval('customer_customer_id_seq', (select max(customer_id) + 1 from customer), false);
select 'reset seq film_film_id_seq', setval('film_film_id_seq', (select max(film_id) + 1 from film), false);
select 'reset seq inventory_inventory_id_seq', setval('inventory_inventory_id_seq', (select max(inventory_id) + 1 from inventory), false);
select 'reset seq language_language_id_seq', setval('language_language_id_seq', (select max(language_id) + 1 from language), false);
select 'reset seq payment_payment_id_seq', setval('payment_payment_id_seq', (select max(payment_id) + 1 from payment), false);
select 'reset seq rental_rental_id_seq', setval('rental_rental_id_seq', (select max(rental_id) + 1 from rental), false);
select 'reset seq staff_staff_id_seq', setval('staff_staff_id_seq', (select max(staff_id) + 1 from staff), false);
select 'reset seq store_store_id_seq', setval('store_store_id_seq', (select max(store_id) + 1 from store), false);

--
-- FOREIGN KEYS
-- 

-- Because table `store` created before staff。
-- foreign REFERENCES define after table `staff` loaded data
alter table store add CONSTRAINT store_manager_staff_id_fkey 
FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;

-- msyql cause
-- todo CONSTRAINT film_original_language_id_fkey FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
