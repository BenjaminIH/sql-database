USE business_trips_db;

DROP TABLE IF EXISTS green_countries;
CREATE TABLE green_countries AS
SELECT 
    population.country, 
    population.code, 
    aggregated.total_score
FROM 
    population
LEFT JOIN (
    SELECT 
        code, 
        SUM(score) AS total_score
    FROM (
        SELECT code, score FROM travel
        UNION ALL
        SELECT code, score FROM deforestation
        UNION ALL
        SELECT code, score FROM air_pollution
        UNION ALL
        SELECT code, score FROM energy
        UNION ALL
        SELECT code, score FROM plastic_pollution
    ) AS merged_topics
    GROUP BY code
) AS aggregated ON population.code = aggregated.code;