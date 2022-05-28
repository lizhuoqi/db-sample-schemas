/*

views:
    v_customer_list

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
 