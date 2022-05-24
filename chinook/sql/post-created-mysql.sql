
--
-- invalid datetime with timestamp(6)
-- change data type to datetime

alter table employee modify column birth_date datetime;
alter table employee modify column hire_date datetime;

