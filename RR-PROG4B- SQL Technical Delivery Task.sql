SELECT *
FROM countries; -- see an overview of countries table

SELECT *
FROM population_years; -- see an overview of population years table

--How many entries in the database are from Africa?

SELECT COUNT(continent) AS continent_africa  -- I selected continent field values and used count to have the total number of continent
FROM countries
WHERE continent ='Africa';	--I used WHERE clause to find continent that is Africa to get the total number of entries from Africa

--What was the total population of Africa in 2010?

SELECT SUM(population) AS total_pop    --checking the total population
FROM population_years AS p;

SELECT SUM(population) AS total_pop    --I used SUM function to find total number of population
FROM population_years AS p
LEFT JOIN		-- LEFT JOIN a_pop subquery to get continent in Africa
		(SELECT id, continent
		FROM countries AS c
		WHERE continent = 'Africa') AS a_pop
ON p.id = a_pop.id
WHERE p.year = 2010;	--specifying that I only want population in year 2010

-- What is the average population of countries in South America in 2000?

SELECT AVG(population) AS avg_pop	--first checking the average population in year 2000
FROM population_years AS p
LEFT JOIN				-- LEFT JOIN southam_pop subquery to get continent equal to South America
		(SELECT id, continent
		FROM countries AS c
		WHERE continent = 'South America') AS southam_pop   -- specifying that we only want to see continents in South America and in year 2000
ON p.id = southam_pop.id
WHERE year = 2000; -- results is  28

-- What country had the smallest population in 2007?

/*SELECT name, p.population
FROM countries AS c
LEFT JOIN
	(SELECT MIN(population) AS min_pop
	FROM population_years  AS p
	WHERE year = 2007) AS small_pop_2007
ON c.id = small_pop_2007.min_pop
WHERE min_pop = small_pop_2007.min_pop -- not necessary since i am already getting the min population with the subquery
;*/

SELECT c.name, p.population   -- was not able to figure out what went wrong with the above code so I asked chatgpt what went wrong
FROM countries AS c
JOIN population_years AS p     -- i was using incorrect JOIN condition, I was comparing the id of the countries instead of comparing the population of the country
    ON c.id = p.country_id
    AND p.year = 2007     -- since using JOIN, we declare population_years as alias P and also declaring that we only want years in 2007
JOIN                      -- JOIN the subquery
	(SELECT country_id, MIN(population) AS min_pop
    FROM population_years
    WHERE year = 2007
    GROUP BY country_id) AS small_pop_2007 -- subquery
    ON p.country_id = small_pop_2007.country_id -- adding subquery to countries table
    AND p.population = min_pop -- adds the population field to country
	WHERE min_pop = 0; -- since we want the lowest value in 2007 only
						--shows 58 countries with 0 population in 2007

-- How much has the population of Europe grown from 2000 to 2010?


SELECT c.name, continent, p.population, p.year -- using the same concept as above
FROM countries as c
JOIN population_years AS p     
    ON c.id = p.country_id
    AND p.year BETWEEN 2000 AND 2010     -- using JOIN again as it is comparing population between 2000 and 2010 in EUROPE
JOIN  
	(SELECT country_id, population AS pop  
	FROM population_years AS p
	WHERE year BETWEEN 2000 AND 2010) AS growth -- subquery aliased as growth
ON p.country_id = growth.country_id 
WHERE continent = 'Europe'  -- specifying only continent in Europe
GROUP BY c.name, continent,p.population, p.year --want to group by each section to show in descending order 
ORDER BY p.year DESC;

--wrong needs to compare results of 2000 to 2010 so 2010 result - 2000 result 
--another example from Ian below

SELECT c1.continent as country_1, SUM(p1.population) as pop_2000, SUM(p2.population) as pop_2010, SUM(p2.population) - SUM(p1.population) AS pop_diff
 
FROM dbo.countries as c1
INNER JOIN population_years as p1
ON c1.id = p1.country_id
INNER JOIN population_years as p2
ON c1.id = p2.country_id
 
WHERE p1.year = 2000
	AND p2.year = 2010
 
	AND continent = 'Europe'
 
GROUP BY continent;