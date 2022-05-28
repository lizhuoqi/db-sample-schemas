
create domain datetime as timestamp;


-- 
-- same aggregate as "string_agg", just a alias
--
create or replace aggregate group_concat(text, text)
(
    sfunc = string_agg_transfn,
    stype = internal,
    finalfunc = string_agg_finalfn
);