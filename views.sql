/*
views:
	v_emp_latest_date
	v_current_dept_emp
*/

-- sqlite3 has no "create or replace view"
create view v_emp_latest_date as
SELECT emp_no AS emp_no
     , max( from_date ) AS from_date
     , max( to_date ) AS to_date 
FROM   dept_emp 
GROUP BY emp_no;

-- shows only the current department for each employee
create view v_current_dept_emp as
select l.emp_no    AS emp_no
     , d.dept_no   AS dept_no
     , l.from_date AS from_date
     , l.to_date   AS to_date 
from dept_emp d
inner join v_emp_latest_date l 
using ( emp_no, from_date, to_date)
;
