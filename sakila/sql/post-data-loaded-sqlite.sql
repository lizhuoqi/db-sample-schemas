--
-- auto increment
-- 
-- sqlite3 has no 
-- "alter table ... alter column ... autoincrement",
-- if it must be done, can only be recreated.
-- For now, there is no autoincrement support.
-- It could be an exercize for you.

--
-- update csv null values "\N" to sqlite null
-- 
update payment set rental_id = null where rental_id = '\N';
update rental set return_date = null where return_date  ='\N';
update film set original_language_id = null where original_language_id = '\N';

-- sqlite has no "alter table ... add constraint ..."
-- it can only be recreated.
-- 
-- ALTER TABLE store RENAME TO _store_old_20220524;
-- CREATE TABLE store (
--   store_id int2 NOT NULL,
--   manager_staff_id int2 NOT NULL,
--   address_id int2 NOT NULL,
--   last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
--   PRIMARY KEY (store_id),
--   CONSTRAINT store_address_id_fkey FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
--   CONSTRAINT store_manager_staff_id_fkey FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id),
--   constraint store_manager_staff_id_key UNIQUE (manager_staff_id ASC)
-- );

-- INSERT INTO store (store_id, manager_staff_id, address_id, last_update) 
-- SELECT store_id, manager_staff_id, address_id, last_update 
-- FROM _store_old_20220524;