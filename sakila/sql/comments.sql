-- --
-- comment on table
-- --

comment on table actor is '演员';
comment on table address is '地址';
comment on table category is '类别';
comment on table city is '城市';
comment on table country is '国家';
comment on table customer is '顾客';
comment on table film is '电影';
comment on table film_actor is '电影演员';
comment on table film_category is '电影类别';
comment on table film_text is '电影文本';
comment on table inventory is '存库';
comment on table language is '语言';
comment on table payment is '支付';
comment on table rental is '出租';
comment on table staff is '职员';
comment on table store is '门店';

-- --
-- comment on column
-- --

comment on column actor.actor_id is '演员ID';
comment on column actor.first_name is '名';
comment on column actor.last_name is '姓';
comment on column actor.last_update is '最后更新';
comment on column address.address_id is '地址ID';
comment on column address.address is '地址';
comment on column address.address2 is '地址2';
comment on column address.district is '区';
comment on column address.city_id is '城市ID';
comment on column address.postal_code is '邮政编码';
comment on column address.phone is '电话';
comment on column address.location is '位置';
comment on column address.last_update is '最后更新';
comment on column category.category_id is '类别ID';
comment on column category.name is '影片类别名称';
comment on column category.last_update is '最后更新';
comment on column city.city_id is '城市ID';
comment on column city.city is '城市';
comment on column city.country_id is '国家ID';
comment on column city.last_update is '最后更新';
comment on column country.country_id is '国家ID';
comment on column country.country is '国家';
comment on column country.last_update is '最后更新';
comment on column customer.customer_id is '客户ID';
comment on column customer.store_id is '门店ID';
comment on column customer.first_name is '名';
comment on column customer.last_name is '姓';
comment on column customer.email is '电子邮件';
comment on column customer.address_id is '地址ID';
comment on column customer.active is '是否活跃';
comment on column customer.create_date is '创建日期';
comment on column customer.last_update is '最后更新';
comment on column film.film_id is '电影ID';
comment on column film.title is '片名';
comment on column film.description is '内容简介';
comment on column film.release_year is '发布年份';
comment on column film.language_id is '影片语言ID';
comment on column film.original_language_id is '原片语言ID';
comment on column film.rental_duration is '出租期限';
comment on column film.rental_rate is '租金率';
comment on column film.length is '片长';
comment on column film.replacement_cost is '更换费用';
comment on column film.rating is '评级';
comment on column film.special_features is '特别说明';
comment on column film.last_update is '最后更新';
comment on column film_actor.actor_id is '演员ID';
comment on column film_actor.film_id is '电影ID';
comment on column film_actor.last_update is '最后更新';
comment on column film_category.film_id is '电影ID';
comment on column film_category.category_id is '类别ID';
comment on column film_category.last_update is '最后更新';
comment on column film_text.film_id is '电影ID';
comment on column film_text.title is '片名';
comment on column film_text.description is '内容简介';
comment on column inventory.inventory_id is '库存ID';
comment on column inventory.film_id is '电影ID';
comment on column inventory.store_id is '门店ID';
comment on column inventory.last_update is '最后更新';
comment on column language.language_id is '语言ID';
comment on column language.name is '语言名称';
comment on column language.last_update is '最后更新';
comment on column payment.payment_id is '付款ID';
comment on column payment.customer_id is '客户ID';
comment on column payment.staff_id is '员工编号';
comment on column payment.rental_id is '出租ID';
comment on column payment.amount is '数量';
comment on column payment.payment_date is '付款日期';
comment on column payment.last_update is '最后更新';
comment on column rental.rental_id is '租赁ID';
comment on column rental.rental_date is '出租日期';
comment on column rental.inventory_id is '库存ID';
comment on column rental.customer_id is '客户ID';
comment on column rental.return_date is '归还日期';
comment on column rental.staff_id is '员工ID';
comment on column rental.last_update is '最后更新';
comment on column staff.staff_id is '员工ID';
comment on column staff.first_name is '名';
comment on column staff.last_name is '姓';
comment on column staff.address_id is '地址ID';
comment on column staff.picture is '头像';
comment on column staff.email is '电子邮件';
comment on column staff.store_id is '门店ID';
comment on column staff.active is '活跃的';
comment on column staff.username is '用户名';
comment on column staff.password is '密码';
comment on column staff.last_update is '最后更新';
comment on column store.store_id is '门店ID';
comment on column store.manager_staff_id is '门店管理员ID';
comment on column store.address_id is '地址ID';
comment on column store.last_update is '最后更新';