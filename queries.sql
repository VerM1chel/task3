-- 1
SELECT name, COUNT(film_id) as films_count
FROM category
INNER JOIN film_category fc on category.category_id = fc.category_id
GROUP BY name
ORDER BY films_count DESC;


-- 2
SELECT first_name, last_name, COUNT(rental_duration) as rentals
FROM film_actor
INNER JOIN film f ON film_actor.film_id=f.film_id
INNER JOIN actor a ON film_actor.actor_id=a.actor_id
GROUP BY first_name, last_name
ORDER BY rentals DESC
LIMIT 10;


-- 3
SELECT name, SUM(amount) as payed_money
FROM payment
INNER JOIN rental r ON payment.rental_id=r.rental_id
INNER JOIN inventory i ON r.inventory_id=i.inventory_id
INNER JOIN film_category fc ON i.film_id=fc.film_id
INNER JOIN category c ON fc.category_id=c.category_id
GROUP BY name
ORDER BY payed_money DESC
LIMIT 1;


-- 4
SELECT title
FROM film
LEFT JOIN inventory i ON film.film_id=i.film_id
WHERE i.film_id IS NULL;


-- 5
SELECT *
FROM (SELECT first_name, last_name, dense_rank() OVER (ORDER BY counts DESC) as top
      FROM (SELECT first_name, last_name, COUNT(c) as counts
            FROM actor
                     INNER JOIN film_actor fa ON actor.actor_id = fa.actor_id
                     INNER JOIN film_category fc ON fa.film_id = fc.film_id
                     INNER JOIN category c ON fc.category_id = c.category_id
            WHERE c.name = 'Children'
            GROUP BY first_name, last_name
            ) as t1
      ) as t2
WHERE top <= 3;


-- 6
SELECT city,
       SUM(CASE WHEN customer.active=1 then 1 else 0 end) as active,
       SUM(CASE WHEN customer.active!=1 then 1 else 0 end) as inactive
FROM address
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN customer ON address.address_id=customer.address_id
GROUP BY city
ORDER BY inactive DESC;


-- 7
SELECT *
FROM (SELECT name, city, sum(extract(epoch from (return_date - rental_date)) / 3600) as hours
      FROM category
               INNER JOIN film_category ON category.category_id=film_category.category_id
               INNER JOIN inventory ON film_category.film_id=inventory.film_id
               INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
               INNER JOIN customer ON rental.customer_id=customer.customer_id
               INNER JOIN address ON customer.address_id=address.address_id
               INNER JOIN city ON address.city_id = city.city_id
      WHERE city LIKE 'A%' OR city LIKE '%-%'
      GROUP BY city, name
      ORDER BY hours DESC) as t
WHERE hours IS NOT NULL
LIMIT 1;
