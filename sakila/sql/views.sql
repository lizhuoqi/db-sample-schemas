/*

views:
    v_customer_list
    v_film_list
    v_nicer_but_slower_film_list  

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
 