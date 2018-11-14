use sakila;

# 1a ******************************
# Simple select statement
select first_name, last_name from actor;

# 1b ******************************
# select with combining two columns into a single column
# also using the force upper (no, not decker)
select concat (upper(first_name)," ",upper(last_name)) as 'Actor Name'
from actor;

# 2a ******************************
# Looking for Joe, has anyone seen Joe?
select actor_id, first_name, last_name from actor
where first_name = 'Joe';

# 2b ******************************
# looking for actors with 'gen' in last name
select * from actor
where last_name like '%GEN%';

# 2c ******************************
# looking for last names with 'li' and sorting on multiple columns
select * from actor
where last_name like '%LI%'
order by last_name, first_name;

# 2d ******************************
# just a way to find the table name INFORMATION_SCHEMA
# I used this basic query to view columns within the tables 
# to map out the associations
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and column_name in ('country_id','country');
 
select country_id, country from country
where country in ('Afghanistan','Bangladesh','China');

# 3a ******************************
# Adding new column as a blob then validating schema change
ALTER TABLE actor
ADD COLUMN description blob AFTER last_name;

SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('actor');

# 3b ******************************
# Removing the column and validating schema change
alter table actor
drop column description;

SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('actor');
 
# 4a ******************************
# Grab last names and perform a count
select last_name, count(last_name)
from actor
group by last_name;

# 4b ******************************
# Grabbing last names, performing a count
# Only displaying count >= 2
select last_name, count(last_name) as 'Name_Count'
from actor
group by last_name
having Name_Count >= 2;

# 4c ******************************
# Looking for a specific actor to grab the actor ID
# then changing value for the actor's first name
select * from actor
where first_name = 'GROUCHO' and last_name like 'WILL%';

update actor
set first_name = 'HARPO'
where actor_id = 172;

# 4d ******************************
# Apparently we're dunder heads and need to change the first name back
update actor
set first_name = 'GROUCHO'
where actor_id = 172;

# 5a ******************************
# This is a new one for me, must do some additional reading
show create table address;

# 6a ******************************
# Again looking at the tables and mapping stuff out in my head
# Simple join of two tables that share a common key
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('staff','address');
 
select a.first_name, a.last_name, b.address, b.address2, b.district
 from staff a 
 join address b using (address_id);

 
# 6b ******************************
# using join again, this time adding some criteria
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('staff','payment');
 
select a.first_name, a.last_name, sum(b.amount)
 from staff a 
 join payment b using (staff_id)
 where b.payment_date like '2005-08%'
 group by first_name, last_name;

# 6c ******************************
# Using an inner join and a count
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('film_actor','film');
 
select a.title, count(b.actor_id) as "Actor Count"
 from film a 
 inner join film_actor b using (film_id)
 group by a.title;
 
# 6d ******************************
# Grabbing # of copies of a specific movie
select a.title, count(b.film_id)
from film a
inner join inventory b using (film_id)
where a.title = 'HUNCHBACK IMPOSSIBLE';

# 6e ******************************
# Join, sum, grouping, and ordering, oh my
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('payment','customer');
 
select a.first_name, a.last_name, sum(b.amount)
from customer a
left join payment b using (customer_id)
group by a.first_name, a.last_name
order by a.last_name;

# 7a ******************************
# nested query happy fun time
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('film','language');
 
select * 
from film
where (title like 'K%'
or title like 'Q%')
and language_id = (select language_id from language
 where name = 'English');
 
# 7b ******************************
# Double nested query
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('film_actor','film','actor');

select * from actor
where actor_id in (
select actor_id from film_actor
where film_id in (select film_id
from film
where title = 'ALONE TRIP'));

# 7c ******************************
# Triple nested query, come get some
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('address','country','customer','city');
 
 select first_name, last_name, email
 from customer
 where address_id in
 (select address_id from address
 where city_id in
 (select city_id from city
 where country_id = 
 (select country_id from country
 where country = 'Canada')));
 
# 7d ******************************
# Family films via the nested query method
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('film','film_category','category');

select * from film
where film_id in
(select film_id from film_category
where category_id in 
(select category_id from category
where name = 'Family'));

# 7e ******************************
# did this one twice, once using "where" and then with the more traditional Joins
# Actually did the remaining questions using this method as I am more accustomed to
# using 'where' vs 'join'
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('film','rental','inventory');

# I assume the question is to to order descending by the number
# of times rented, and not by title
select a.title, count(c.rental_id) as 'Frequency'
from film a, inventory b, rental c
where a.film_id = b.film_id
and b.inventory_id = c.inventory_id
group by a.title
order by Frequency desc;

# or

select a.title, count(c.rental_id) as 'Frequency'
from film a #, inventory b, rental c
 join inventory b
  on b.film_id = a.film_id
 join rental c
  on c.inventory_id = b.inventory_id
group by a.title
order by Frequency desc;

# 7f ******************************
# total monies for each store, used 4 tables
select a.store_id, sum(d.amount) as "Total Revenue"
from store a, staff b, rental c, payment d
where a.store_id = b.store_id
and b.staff_id = c.staff_id
and c.rental_id = d.rental_id
group by a.store_id;

# or

select a.store_id, sum(d.amount) as "Total Revenue"
from store a #, inventory b, rental c
 join staff b
  on b.store_id = a.store_id
 join rental c
  on c.staff_id = b.staff_id
 join payment d
  on d.rental_id = c.rental_id
group by a.store_id;

# 7g ******************************
# Store locations from across 3 tables
select a.store_id, c.city, d.country
from store a, address b, city c, country d
where a.address_id = b.address_id
and b.city_id = c.city_id
and c.country_id = d.country_id;

# or

select a.store_id, c.city, d.country
from store a #, inventory b, rental c
 join address b
  on b.address_id = a.address_id
 join city c
  on c.city_id = b.city_id
 join country d
  on d.country_id = c.country_id;

# 7h ******************************
# top 5 movies by gross monies
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_KEY,DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_schema = 'sakila'
 and TABLE_NAME in ('category','film_category','inventory','payment','rental');

select a.name, sum(d.amount) as "Gross_Revenue"
from category a, film_category b, inventory c, payment d, rental e
where a.category_id = b. category_id
and b.film_id = c.film_id
and c.inventory_id = e.inventory_id
and e.rental_id = d.rental_id
group by a.name
order by Gross_Revenue desc
limit 5;

# or

select a.name, sum(e.amount) as "Gross_Revenue"
from category a 
 join film_category b
  on b.category_id = a.category_id
 join inventory c
  on c.film_id = b.film_id
 join rental d
  on d.inventory_id = c.inventory_id
 join payment e
  on e.rental_id = d.rental_id
group by a.name
order by Gross_Revenue desc
limit 5;

# 8a ******************************
drop view if exists Homework7_8a;

create view Homework7_8a as
select a.name, sum(d.amount) as "Gross_Revenue"
from category a, film_category b, inventory c, payment d, rental e
where a.category_id = b. category_id
and b.film_id = c.film_id
and c.inventory_id = e.inventory_id
and e.rental_id = d.rental_id
group by a.name
order by Gross_Revenue desc
limit 5;