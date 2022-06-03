/*

functions:
    get_emp_dept_id
    get_emp_dept_name
    get_emp_name
    get_current_manager
    show_departments
    employees_usage
    show_employees_help

*/


--
-- returns the department id of a given employee
--
create or replace function get_emp_dept_id( employee_id int )
returns char(4)
language plpgsql
as $$
    begin
        return (
            select dept_no
            from   (
                select dept_no as dept_no
                     , ROW_NUMBER() over(order by from_date desc) as rn
                from   dept_emp
                where  emp_no = employee_id
            ) depts
            where rn = 1
        );
    end 
$$
;


--
-- returns the department name of a given employee
--

create or replace function get_emp_dept_name( employee_id int )
returns varchar(40)
language plpgsql
as $$
    begin
        return (
            select dept_name
            from   departments
            where  dept_no = get_emp_dept_id(employee_id)
        );
    end
$$;

--
-- returns the employee name of a given employee id
--
create or replace function get_emp_name (employee_id int)
returns varchar(32)
language plpgsql
as $$
    begin
        return (
            select concat(first_name, ' ', last_name) as name
            from   employees
            where  emp_no = employee_id
        );
    end;
$$;


--
-- returns the manager of a department
-- choosing the most recent one
-- from the manager list
--
create or replace function get_current_manager( dept_id char(4) )
returns varchar(32)
language plpgsql
as $$
    begin
        return (
            select get_emp_name(emp_no)
            from   (
                select dept_no
                     , emp_no
                     , ROW_NUMBER() over(order by to_date desc) as rn
                from   dept_manager
                where  dept_no = dept_id
            ) depts
            where rn = 1
        );
    end;
$$;

--
-- shows the departments with the number of employees
-- per department
--
-- postgres can't return query result set throught procedure
-- use the table-valued function instead.
-- usage: select * from show_departments();
create or replace function show_departments()
    returns 
    table (
          dept_no char
        , dept_name varchar
        , manager varchar
        , counts  int
    )
    language sql
as $$
    select depts.dept_no
         , depts.dept_name
         , depts.manager    
         , count(emps.emp_no)
    from   (
        select dept_no
             , emp_no
             , ROW_NUMBER() over( partition by emp_no order by to_date desc) as rn
        from   dept_emp
    ) emps
    inner join v_full_departments depts
    on    emps.dept_no = depts.dept_no
    and   emps.rn = 1
    group by depts.dept_no
         , depts.dept_name
         , depts.manager   ;
$$;


create or replace function get_employees_usage()
    returns text
    language sql
    as $$

    select
'
    == USAGE ==
    ====================

    PROCEDURE show_departments()

        shows the departments with the manager and
        number of employees per department

    FUNCTION current_manager (dept_id)

        Shows who is the manager of a given departmennt

    FUNCTION emp_name (emp_id)

        Shows name and surname of a given employee

    FUNCTION emp_dept_id (emp_id)

        Shows the current department of given employee
'

end $$;


create or replace procedure show_employees_help(inout info text default null)
-- deterministic
    language plpgsql
    as $$
begin
--     help := (select employees_usage());
    select get_employees_usage() into info;
end
$$;

-- do $$
-- declare o text := ' '::text ;
-- begin
--   call employees_help(o);
--   RAISE NOTICE 'o = %', o;  -- prints o
-- end;
-- $$

