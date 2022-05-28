
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


--
-- recreate view `v_actor_info`
--

create or replace view v_actor_info as
with actor_films as
(
  select act.actor_id
       , first_name
       , last_name
       , category.name category
       , string_agg(film.title, ', '  order by film.title) films
  from   actor act
  left   join film_actor    using (actor_id)
  left   join film_category using (film_id)
  left   join category      using (category_id)
  left   join film          using (film_id)
  group  by act.actor_id, category
)
select actor_id
     , first_name
     , last_name
     , string_agg(
         category || ': ' || films
         , '; ' order by category )  as film_info
from   actor_films
group  by actor_id, first_name, last_name;