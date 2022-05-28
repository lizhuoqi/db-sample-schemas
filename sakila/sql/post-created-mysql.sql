
--
-- blob field
--

alter table staff add column picture blob;

-- 
-- SET type
--

alter table film modify column special_features 
SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes');


-- 
-- recreate views with function `concat`
--

create view v_customer_list as 
select cust.customer_id as id
       -- mysql 8 can't get the right name by using concat operator "||"
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