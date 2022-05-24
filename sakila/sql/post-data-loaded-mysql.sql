
--
-- add sequences and set sequences nextval
-- mysql auto_increment will start with max(id) + 1
-- 
alter table actor modify column actor_id int2 auto_increment;
alter table address modify column address_id int2 auto_increment;
alter table category modify column category_id int2 auto_increment;
alter table city modify column city_id int2 auto_increment;
alter table country modify column country_id int2 auto_increment;
alter table customer modify column customer_id int2 auto_increment;
alter table film modify column film_id int2 auto_increment;
alter table inventory modify column inventory_id int auto_increment;
alter table language modify column language_id int2 auto_increment;
alter table payment modify column payment_id int2 auto_increment;
alter table rental modify column rental_id int auto_increment;
alter table staff modify column staff_id int2 auto_increment;
alter table store modify column store_id int2 auto_increment;

--
-- FOREIGN KEYS
-- 
-- table "store" and "staff" refer to echo other.
alter table store add CONSTRAINT store_manager_staff_id_fkey 
FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;

-- msyql cause
-- todo CONSTRAINT film_original_language_id_fkey FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
