-- CREATE TABLE

CREATE TABLE TABLE netflix
(
show_id VARCHAR(7),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
cast VARCHAR(1000),
country VARCHAR(150),
date_added VAR VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description (250)
);



SELECT *
FROM netflix;


SELECT COUNT (*) AS total_content
FROM netflix;

SELECT 
	DISTINCT type
FROM netflix;




-- BUSINESS PROBLEMS

-- 1. Count the number of Movies vs TV shows


SELECT *
FROM netflix;


SELECT type, 
	COUNT(*) as total_content
FROM netflix
GROUP BY type;


-- 2. Find the most common rating for movies and TV shows 

SELECT *
FROM netflix;


SELECT type, 
		rating
FROM netflix;


WITH rating AS 
(
SELECT 
	type, 
	rating, 
	COUNT(*) total_rating, 
	RANK () OVER (PARTITION BY type ORDER BY COUNT(*) DESC) ranking
FROM netflix
GROUP BY type, rating
)
SELECT 
	type,
	rating
FROM rating
WHERE ranking = 1;


--3.  List all movies released in a specific year (e.g 2020)

SELECT *
FROM netflix;

SELECT *
FROM netflix
WHERE 
	type = 'Movie' 
	AND 
	release_year = 2020
;




-- 4. Find the top 5 countries  with the most content on Netflix

SELECT *
FROM netflix;

SELECT UNNEST(STRING_TO_ARRAY(country, ',')) new_country, count(*) total_content
FROM netflix
GROUP BY new_country
ORDER BY count(*) DESC
LIMIT 5;

SELECT Country
FROM netflix;


SELECT UNNEST(STRING_TO_ARRAY(country, ','))
FROM netflix;


-- Identify the longest movie?

SELECT *
FROM netflix;

SELECT *
FROM netflix
WHERE 
	duration = (SELECT MAX(duration)
					FROM netflix);

-- 6. Find content added in the last 5 years

SELECT date_added, TO_DATE(date_added, 'Month DD, YYYY')
FROM netflix;

SELECT CURRENT_DATE - INTERVAL '5 years';


SELECT *
FROM netflix
WHERE 
	TO_DATE(date_added, 'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT *
FROM netflix;

SELECT *
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix
;

SELECT *, SUBSTRING(duration, 1,1) new_duration
FROM netflix
WHERE type = 'TV Show'
AND
SUBSTRING(duration, 1,1)::numeric > 5;



SELECT *, 
	SPLIT_PART(duration, ' ',1) new_duration
FROM netflix
WHERE type = 'TV Show'
AND
SPLIT_PART(duration, ' ',1)::numeric > 5;

-- 9. Count the number of content items in each genre

SELECT *
FROM netflix;

SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) genre, COUNT(*)
FROM netflix
GROUP BY genre;
;

-- 10. Find each year and the average number of content release in India on netflix.
--     return top 5 year with highest avg content release


SELECT *
FROM netflix;

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'MONTH DD, YYYY')) R_year, 
	COUNT(*), 
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix where country = 'India')::numeric * 100,2)
FROM netflix
WHERE country = 'India'
GROUP BY R_year;


-- 11. List all movies that are documetaries

SELECT *
FROM netflix;


SELECT *
FROM netflix
WHERE type = 'Movie'
AND listed_in LIKE '%Documentaries%';

-- 12. Find all content without a director

SELECT * 
FROM netflix;


SELECT *
FROM netflix
WHERE director IS NULL;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT *
FROM netflix;

SELECT *
FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND 
release_year >= EXTRACT(YEAR  FROM CURRENT_DATE) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT country
FROM netflix
WHERE country LIKE '%India%'
ORDER by country;

SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) actors, COUNT(*) 
FROM netflix
WHERE country LIKE '%India%'
GROUP BY actors
ORDER BY count DESC
LIMIT 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in
--		the description field. Label content containing these keywords as 'Bad' and all other
--		content as 'Good'. Count how many items fall into each category


SELECT *
FROM netflix;

WITH new_table
AS (
SELECT *,
	CASE
		WHEN description ILIKE '%Kill%'
		OR description ILIKE '%violence%' THEN 'Bad'
		ELSE 'Good'
	END AS category
FROM netflix
)
SELECT 
	category, count(*) total_content
FROM new_table
GROUP BY category;