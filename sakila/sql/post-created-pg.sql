
--
-- blob field
--

alter table staff add column picture bytea;


--
-- mysql type set alternative
-- 

-- special_features SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
-- alter table file alter column special_features text[];


--
-- recreate view `v_nicer_but_slower_film_list`
-- with postgres func `initcap`
--

create or replace view v_nicer_but_slower_film_list as
select film.film_id       as fid
     , film.title
     , film.description
     , cat.name           as category
     , film.rental_rate   as price
     , film.length
     , film.rating
     , group_concat(
                  initcap(actor.first_name)
               || ' '
               || initcap(actor.last_name)
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
