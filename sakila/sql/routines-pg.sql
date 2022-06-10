/*

functions:
    get_customer_balance
    inventory_held_by_customer
    inventory_in_stock
    rewards_report
procedure:
    film_in_stock
    film_not_in_stock
*/

create or replace function get_customer_balance(p_customer_id customer.customer_id%type, p_effective_date timestamp) 
    RETURNS DECIMAL(5,2)
    -- DETERMINISTIC
    language plpgsql as $$
  DECLARE v_rentfees DECIMAL(5,2); --#FEES PAID TO RENT THE VIDEOS INITIALLY
  DECLARE v_overfees INTEGER;      --#LATE FEES FOR PRIOR RENTALS
  DECLARE v_payments DECIMAL(5,2); --#SUM OF PAYMENTS MADE PREVIOUSLY
BEGIN

       -- #OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       -- #THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       -- #   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       -- #   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       -- #   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       -- #   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

    with overdue as 
    (
        select film.rental_rate
             , rental.return_date - rental.rental_date  duration
             , film.rental_duration * '1 day'::interval rental_duration
             , film.replacement_cost
             , rental.customer_id
        -- into   v_rentfees, v_overfees
        from   rental
        inner  join inventory
        on     rental.inventory_id = inventory.inventory_id
        and    rental.customer_id = p_customer_id
        and    rental.rental_date <= p_effective_date
        inner  join film
        on     film.film_id = inventory.film_id
    )
    select sum(rental_rate)
         , sum(
               case 
               when duration > rental_duration * 2 then replacement_cost
               when duration > rental_duration
               then extract( days from (duration - rental_duration))
                    -- dontforget
                    + case when extract( hours from (duration - rental_duration)) > 0 then 1 else 0 end 
               end 
           ) overfees
    into   v_rentfees, v_overfees
    from   overdue;

    select coalesce(sum(amount), 0)
    into   v_payments
    from   payment
    where  payment_date <= p_effective_date
    and    customer_id = p_customer_id;

    RETURN v_rentfees + v_overfees - v_payments;
END $$
;


create or replace function inventory_in_stock(p_inventory_id INT) 
    RETURNS BOOLEAN
    language plpgsql
as $$
    DECLARE v_rentals INT;
    DECLARE v_out     INT;
BEGIN

    -- #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    -- #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END
$$;

create or replace function inventory_held_by_customer(p_inventory_id INT) 
    RETURNS INT
    language plpgsql
as $$
  DECLARE v_customer_id INT;

BEGIN

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END $$;


create or replace procedure film_in_stock(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
language plpgsql
as $$
BEGIN

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END $$;


create or replace procedure film_not_in_stock(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
language plpgsql
as $$
BEGIN

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id)
     INTO p_film_count;
END $$;


create or replace function rewards_report (
      min_monthly_purchases int
    , min_dollar_amount_purchased DECIMAL(10,2)
    , last_month date default CURRENT_DATE
)

-- LANGUAGE SQL
-- NOT DETERMINISTIC
-- READS SQL DATA
-- SQL SECURITY DEFINER
-- COMMENT 'Provides a customizable report on best customers'
returns setof customer
language plpgsql
as $$
declare
    v_last_month date;
    v_last_month_start DATE;
    v_last_month_end DATE;
BEGIN

    /* Some sanity checks... */
    assert min_monthly_purchases > 0, 'Minimum monthly purchases parameter must be > 0';

    assert min_dollar_amount_purchased > 0.00, 'Minimum monthly dollar amount purchased parameter must be > $0.00';

    /* Determine start and end time periods */
    v_last_month := date_trunc('month', last_month);
    v_last_month_start := date_trunc('month', v_last_month - interval '1 month');
    v_last_month_end := v_last_month_start + '1 month'::interval - '1 day'::interval;

    /*
        Output ALL customer information of matching rewardees.
        Customize output as needed.
    */
    return query
    with pay as
    (
      select customer_id
  --         , payment_date
      from   payment
      where  payment_date BETWEEN v_last_month_start AND v_last_month_end
      group  by customer_id
      having SUM(amount) > min_dollar_amount_purchased
      and    COUNT(1) > min_monthly_purchases
    )
    select customer.*
    from   pay
    inner  join customer
    using  (customer_id);
END $$
;
comment on function rewards_report is 'Provides a customizable report on best customers';
