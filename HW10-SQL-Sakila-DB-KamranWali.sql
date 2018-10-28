
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
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

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

UPDATE actor
SET FIRST_NAME = 'HARPO'
WHERE LAST_NAME = 'WILLIAMS'
AND FIRST_NAME = 'GROUCHO';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
--     It turns out that `GROUCHO` was the correct name after all! In a single query, 
--     if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

UPDATE actor
SET FIRST_NAME = 'GROUCHO'
WHERE FIRST_NAME = 'HARPO'
AND LAST_NAME = 'WILLIAMS';


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

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
--     films starting with the letters K and Q have also soared in popularity. 
--     Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT * FROM film
WHERE (title LIKE 'K%'
OR title LIKE 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT * FROM actor A 
WHERE EXISTS (SELECT '1' FROM film_actor FA, film F 
               WHERE A.actor_id = FA.actor_id
               AND FA.film_id = F.film_id
               AND F.title = 'ALONE TRIP');
               
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
--     of all Canadian customers. Use joins to retrieve this information.
               
SELECT CU.first_name, CU.last_name, CU.email
FROM customer CU
WHERE EXISTS (SELECT '1' FROM address AD, city CY, country CN
              WHERE CU.address_id = AD.address_id
              AND AD.city_id = CY.city_id
              AND CY.city_id = CN.country_id
              AND CN.country = 'Canada');

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
--     Identify all movies categorized as family films.   

SELECT * FROM film F
WHERE EXISTS (SELECT '1' FROM film_category FC, category C
              WHERE F.film_id = FC.film_id
              AND FC.category_id = C.category_id
              AND C.name = 'Family');
              
-- 7e. Display the most frequently rented movies in descending order.

SELECT F.title, COUNT(F.title) as 'MOST_RENTED'                 
FROM film F                                              
JOIN inventory I                                         
on(F.film_id = I.film_id)                    
JOIN rental R                                            
ON (I.inventory_id = R.inventory_id)       
GROUP by F.title                                          
ORDER BY MOST_RENTED desc;  

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT S.store_id, SUM(P.amount) AS TOTAL_AMOUNT        
FROM payment P                                 
JOIN rental R                                  
ON (P.rental_id = R.rental_id)                 
JOIN inventory I                              
ON ( I.inventory_id = R.inventory_id)          
JOIN store S                                   
ON (S.store_id = I.store_id)                   
GROUP BY S.store_id; 

-- 7g. Write a query to display for each store its store ID, city, and country. 

SELECT ST.store_id, CY.city, CN.country
FROM store ST 
JOIN address AD
ON (ST.address_id = Ad.address_id)
JOIN CITY CY
ON (AD.city_id = CY.city_id)
JOIN country CN
ON (CN.country_id = CY.country_id);

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, 
--     film_category, inventory, payment, and rental.)

SELECT c.name, sum(p.amount) 
FROM category c
JOIN film_category fc
ON (c.category_id = fc.category_id)
JOIN inventory i
ON (i.film_id = fc.film_id)
JOIN rental r
ON (r.inventory_id = i.inventory_id)
JOIN payment p
ON (p.rental_id = r.rental_id)
GROUP BY c.name
ORDER BY sum(p.amount) DESC
LIMIT 5

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
--     Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW sakila.top_five_genres AS
SELECT c.name, sum(p.amount) AS 'gross_amount'
FROM category c
JOIN film_category fc
ON (c.category_id = fc.category_id)
JOIN inventory i
ON (i.film_id = fc.film_id)
JOIN rental r
ON (r.inventory_id = i.inventory_id)
JOIN payment p
ON (p.rental_id = r.rental_id)
GROUP BY c.name
ORDER BY sum(p.amount) DESC
LIMIT 5

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM sakila.top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW sakila.top_five_genres;


                                                                             




                                                                                 









                      








 

    

              
              
              







                        































