
-- auto increment

--
-- update csv null values "\N" to sqlite null
-- 
update payment set rental_id = null where rental_id = '\N';
update rental set return_date = null where return_date  ='\N';
update film set original_language_id = null where original_language_id = '\N';
