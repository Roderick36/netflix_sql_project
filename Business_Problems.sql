-- NETFLIX
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id VARCHAR(10),
	type	VARCHAR(10),
	title	VARCHAR(150),
	director VARCHAR(210),	
	castS	VARCHAR(1000),
	country		VARCHAR(150),
	date_added	VARCHAR(50),
	release_year INT,
	rating	VARCHAR(15),
	duration VARCHAR(15),
	listed_in	VARCHAR(100),
	description VARCHAR(250)
);

-- 15 Business Problems & Solutions

SELECT * FROM netflix

--1. Count the number of Movies vs TV Shows
SELECT 
	type,
	count(*) as total
from netflix
group by type


--2. Find the most common rating for movies and TV shows
SELECT 
	type,
	rating
from	
(SELECT 
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS RNK
from netflix
GROUP BY 1,2
) as t1
where rnk = 1

SELECT 
	type,
	rating,
	count(*) as total,
	RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC ) AS RANK
	FROM NETFLIX
	group by type, rating
	
--3. List all movies released in a specific year (e.g., 2020)
select * from netflix
select 
	type,
	title,
	release_year
from netflix
where type = 'Movie' and release_year = 2020
		


4. Find the top 5 countries with the most content on Netflix
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as NEW_COUNTRY,
	COUNT(show_id) as total_content
	FROM netflix
	group by 1
	ORDER BY 2 DESC
	LIMIT 5

-- 5. Identify the longest movie
select * from netflix
where 
	type = 'Movie'
	AND 
	duration = (select max(duration)from netflix)
	
--6. Find content added in the last 5 years
 	SELECT 
	 *	 
	 FROM NETFLIX
	 WHERE 
	 	TO_DATE(date_added, 'Month, DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

	 
-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
	SELECT 
		type,
		director,
		title
	FROM netflix
	WHERE director ='Rajiv Chilaka'

	SELECT * FROM netflix
	where director like '%Rajiv Chilaka%'


--8. List all TV shows with more than 5 
	SELECT * FROM netflix
	WHERE
		type = 'TV Show' and
		SPLIT_PART(duration, ' ',1)::numeric >5
		

--9. Count the number of content items in each genre

	SELECT 
		UNNEST(STRING_TO_ARRAY(listed_in, ',')) as Genre,
		COUNT(show_id) AS Total_Content
	FROM netflix
		GROUP BY 1

--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

	SELECT 
		EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS DATE,
		COUNT(*) as Yearly_Content,
		ROUND(
		COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix where country ='India') * 100 , 2) as Average_Content_PerYear
	FROM netflix
	WHERE country = 'India' 
	GROUP BY 1

11. List all movies that are documentaries
	SELECT * FROM netflix
	WHERE listed_in ILIKE '%documentaries%'

12. Find all content without a director
	SELECT * FROM netflix
	WHERE director IS NULL
	
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
	SELECT * FROM netflix
	WHERE casts ILIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) -10

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
	SELECT 
		UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
		COUNT(*) as total_content
	FROM netflix
	WHERE country ILIKE '%India'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10
	
	
	
15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


	WITH new_table 
	as
	(
	SELECT	 *,
		CASE 
		WHEN 
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad_Content'
		Else 'Good Content'
		END Category
	FROM netflix
	)
	SELECT 
		Category,
		COUNT(*) AS total_content
	from new_table
	group by 1
	
	