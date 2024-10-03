USE business_trips_db;

DROP TABLE IF EXISTS green_countries;
CREATE TABLE green_countries AS
SELECT 
    population.country, 
    population.code,
    population.population,
    aggregated.total_score
FROM 
    population
LEFT JOIN (
    SELECT 
        code, 
        SUM(score) AS total_score
    FROM (
        SELECT code, score * 5 AS score FROM travel
        UNION ALL
        SELECT code, score * 3 AS score  FROM deforestation
        UNION ALL
        SELECT code, score * 10 AS score FROM air_pollution
        UNION ALL
        SELECT code, score * 6 AS score FROM energy
        UNION ALL
        SELECT code, score * 4 AS score FROM plastic_pollution
    ) AS merged_topics
    GROUP BY code
) AS aggregated ON population.code = aggregated.code;

DROP VIEW IF EXISTS green_countries_big;
CREATE VIEW green_countries_big AS
SELECT 
    green_countries.country,
    green_countries.code,
    green_countries.population,
    green_countries.total_score
FROM 
    green_countries 
WHERE green_countries.population > 10000000;