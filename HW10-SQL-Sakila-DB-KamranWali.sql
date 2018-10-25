
-- Homework Assignment Kamran Wali  
-- Started 10/14/2018
-- Ended 10/14/2018

-- Switch schema to the sakila database

USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.

SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
--     Name the column `Actor Name`.

SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS Actor_Name
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
--     What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`

SELECT * FROM actor
WHERE UPPER(last_name) LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. 
--     This time, order the rows by last name and first name, in that order

SELECT * FROM actor
WHERE UPPER(last_name) LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
--     Afghanistan, Bangladesh, and China

SELECT * FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')

-- 3a. You want to keep a description of each actor. 
--     You don't think you will be performing queries on a description, 
--     so create a column in the table `actor` named `description` and use the data type `BLOB` 
--     (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor ADD COLUMN description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
--     Delete the `description` column

ALTER TABLE actor DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name

SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 1

-- 4b. List last names of actors and the number of actors who have that last name, 
--     but only for names that are shared by at least two actors

SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
-- Write a query to fix the record.

-- SELECT * FROM ACTOR
-- WHERE LAST_NAME = 'WILLIAMS'

UPDATE actor
SET FIRST_NAME = 'HARPO'
WHERE ACTOR_ID = 172;

-- COMMIT;

SELECT * FROM ACTOR
WHERE ACTOR_ID = 172;

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
--     It turns out that `GROUCHO` was the correct name after all! In a single query, 
--     if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

UPDATE actor
SET FIRST_NAME = 'GROUCHO'
WHERE ACTOR_ID = 172
AND FIRST_NAME = 'HARPO';

-- COMMIT;

-- SELECT * FROM ACTOR
-- WHERE ACTOR_ID = 172;

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

SHOW CREATE TABLE ACTOR;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
--     Use the tables `staff` and `address`:

SELECT s.first_name, s.last_name, a.address
FROM staff s, address a
WHERE s.address_id = a.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
--     Use tables `staff` and `payment`. 

SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff s, payment p
WHERE s.staff_id = p.staff_id
AND MONTH(p.payment_date) = 08
AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. 
--     Use inner join.

SELECT f.title, COUNT(fa.actor_id) AS 'Actors'    
FROM film_actor fa, film f                             
WHERE f.film_id = fa.film_id                         
GROUP BY f.title                                  
ORDER BY Actors desc; 

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT f.title, (SELECT COUNT(i.film_id) from inventory i where i.film_id = f.film_id) AS '# of copies'
FROM film f
WHERE f.title = 'Hunchback Impossible';

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
--     List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, (SELECT SUM(p.amount) FROM payment p WHERE c.customer_id = p.customer_id)
FROM customer c
GROUP BY c.customer_id
ORDER BY c.last_name ASC


                        































