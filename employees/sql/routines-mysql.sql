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

drop function get_emp_dept_id;
drop function get_emp_dept_name;
drop function get_emp_name;
drop function get_current_manager;
drop procedure show_departments;
drop function employees_usage;
drop procedure show_employees_help;


delimiter //

--
-- returns the department id of a given employee
--
create function get_emp_dept_id( employee_id int )
returns char(4)
reads sql data
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
end //


--
-- returns the department name of a given employee
--

create function get_emp_dept_name( employee_id int )
returns varchar(40)
reads sql data
begin
    return (
        select dept_name
        from   departments
        where  dept_no = get_emp_dept_id(employee_id)
    );
end //

--
-- returns the employee name of a given employee id
--
create function get_emp_name (employee_id int)
returns varchar(32)
reads SQL data
begin
    return (
        select concat(first_name, ' ', last_name) as name
        from   employees
        where  emp_no = employee_id
    );
end//

--
-- returns the manager of a department
-- choosing the most recent one
-- from the manager list
--
create function get_current_manager( dept_id char(4) )
returns varchar(32)
reads sql data
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
end //


--
-- shows the departments with the number of employees
-- per department
--
create procedure show_departments()
begin
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
    group by depts.dept_no;
end //

create function get_employees_usage()
    returns text
    deterministic
begin
    return
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
';
end
//

create procedure show_employees_help()
deterministic
begin
    select employees_usage() as info;
end//

delimiter ;