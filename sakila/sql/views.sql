/*

views:
    v_customer_list
    v_film_list
    v_nicer_but_slower_film_list  
    v_staff_list
    v_sales_by_store
    v_sales_by_film_category

*/

--
-- View structure for view `v_customer_list`
--

create view v_customer_list as 
select cust.customer_id as id
       -- mysql 8 can't get the right name by using concat operator "||"
       -- recreated this view "v_customers" in post-created-mysql.sql
     , cust.first_name || ' ' || cust.last_name as name
     , addr.address
     , addr.postal_code as "zip code"
     , addr.phone
     , city.city
     , cont.country
     , case when cust.active then 'active' end notes
     , cust.store_Id as sid
from   customer     as cust
left   join address as addr
using  (address_id)
left   join city
using  (city_id)
left   join country as cont
using  (country_id);

--
-- View structure for view `v_film_list`
--

create view v_film_list
AS
select film.film_id       as fid
     , film.title
     , film.description
     , cat.name           as category
     , film.rental_rate   as price
     , film.length
     , film.rating
     , group_concat(actor.first_name || ' ' || actor.last_name, ', ')
                          as actors
from   film
left   join film_category
using  (film_id)
left   join category      cat
using  (category_id)
left   join film_actor
using  (film_id)
left   join actor
using  (actor_id)
group  by film.film_id, cat.name;


--
-- View structure for view `v_nicer_but_slower_film_list`
--

create view v_nicer_but_slower_film_list as
select film.film_id       as fid
     , film.title
     , film.description
     , cat.name           as category
     , film.rental_rate   as price
     , film.length
     , film.rating
     , group_concat(
               upper(substr(actor.first_name, 1, 1)) || lower(substr(actor.first_name, 2))  
               || ' ' 
               || upper(substr(actor.last_name, 1, 1)) || lower(substr(actor.last_name, 2)) 
               , ', ')    as actors
from   film
left   join film_category
using  (film_id)
left   join category      cat
using  (category_id)
left   join film_actor
using  (film_id)
left   join actor
using  (actor_id)
group  by film.film_id, cat.name;

--
-- View structure for view `v_staff_list`
--

CREATE VIEW v_staff_list
AS
select staff_id       as id
     , first_name || ' ' || last_name 
                      as name
     , address
     , postal_code    as "zip code"
     , phone
     , city
     , country
     , staff.store_id as sid
from   staff
inner  join address using (address_id)
left   join city    using (city_id)
left   join country using (country_id);


--
-- View structure for view `v_sales_by_store`
--

create view v_sales_by_store
as
select city || ', ' || country as store
     , ( select first_name || ', ' || last_name
         from   staff
         where  staff.staff_id = store.manager_staff_id
       )               as manager
     , sum(pay.amount) as total_sales
from   payment as pay
inner  join rental       using (rental_id)
inner  join inventory    using (inventory_id)
inner  join store       using (store_id)
inner  join address      using (address_id)
inner  join city         using (city_id)
inner  join country      using (country_id)
group  by store.store_id, country, city
order  by country, city;

--
-- View structure for view `v_sales_by_film_category`
--
-- Note that total sales will add up to >100% because
-- some titles belong to more than 1 category
--

create view v_sales_by_film_category as
select category.name   as category
     , sum(pay.amount) as total_sales
from   payment as pay
left   join rental        using (rental_id)
left   join inventory     using (inventory_id)
-- left   join film          using (film_id)
left   join film_category using (film_id)
left   join category      using (category_id)
group  by category.name
order  by 2 desc;
 