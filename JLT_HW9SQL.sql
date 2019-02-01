USE sakila;

-- 1a
SELECT first_name, last_name FROM actor;

-- 1b Instruction asked for UPPER however it should be noted that the table values were already upper
SELECT UPPER(CONCAT(first_name, ' ' ,last_name)) AS actor_name FROM actor;

-- 2a
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

-- 2b 
SELECT * FROM actor WHERE last_name LIKE "%Gen%";

-- 2c
SELECT last_name, first_name FROM actor WHERE last_name LIKE "%Ll%"
ORDER BY last_name, first_name;

-- 2d 
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a 
ALTER TABLE actor
ADD description BLOB;

-- 3b 
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE actor
DROP COLUMN description;
SET SQL_SAFE_UPDATES = 1;

-- 4a
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name;

-- 4b 
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name HAVING COUNT(last_name) >= 2; 

-- 4c
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

-- 4d Error Code 1175 said needed to turn off safety
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";
SET SQL_SAFE_UPDATES = 1;

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

-- 6b
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS 'Total Amount'
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment_date LIKE '2005-08%'
GROUP BY first_name, last_name;
 
-- 6c
SELECT film.title, COUNT(film_actor.actor_id) AS 'Number of Actors'
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

-- 6d
SELECT film.title, COUNT(inventory.film_id) AS 'Number of Copies'
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible';

-- 6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Amount Paid'
FROM payment
INNER JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

-- 7a
SELECT film.title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%' 
AND language_id IN
(SELECT language_id 
  FROM language
  WHERE language.name = 'English'); 

-- 7b 
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (SELECT film_id
   FROM film
   WHERE title = 'ALONE TRIP' ));

-- 7c
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id=address.address_id
JOIN city ON address.city_id=city.city_id
JOIN country ON city.country_id=country.country_id
WHERE country = 'Canada';

-- 7d 
SELECT title
 FROM film
 WHERE film_id IN
  (SELECT film_id
   FROM film_category
   WHERE category_id IN
   (SELECT category_id
    FROM category
    WHERE name = 'Family'));

-- 7e 
SELECT title, COUNT(title) AS "Frequency"
FROM film
INNER JOIN inventory ON film.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
GROUP BY film.film_id
ORDER BY Frequency DESC;

-- 7f Formatted in dollars
SELECT staff.store_id, CONCAT("$",FORMAT(SUM(amount),2))  AS "Total Dollars Per Store"
FROM payment
LEFT JOIN staff 
ON payment.staff_id=staff.staff_id
GROUP BY staff.store_id;

-- 7g  
SELECT store.store_id, city.city, country.country
FROM store
JOIN address ON store.address_id=address.address_id
JOIN city ON address.city_id=city.city_id
JOIN country ON city.country_id=country.country_id;
    
-- 7h 
SELECT category.name, SUM(payment.amount) AS "Gross Rev" 
FROM payment
JOIN rental ON payment.rental_id=rental.rental_id
JOIN inventory ON rental.inventory_id=inventory.inventory_id
JOIN film_category ON inventory.film_id=film_category.film_id
JOIN category ON category.category_id=film_category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8a 
CREATE VIEW top5genresgrossrev AS 
SELECT category.name, SUM(payment.amount) AS "Gross_Rev" 
FROM payment
JOIN rental ON payment.rental_id=rental.rental_id
JOIN inventory ON rental.inventory_id=inventory.inventory_id
JOIN film_category ON inventory.film_id=film_category.film_id
JOIN category ON category.category_id=film_category.category_id
GROUP BY category.name
ORDER BY Gross_Rev DESC
LIMIT 5;

-- 8b
SELECT * FROM top5genresgrossrev;

-- 8c
DROP VIEW top5genresgrossrev;

