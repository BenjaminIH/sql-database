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
        UNION
        SELECT code, score FROM deforestation
        UNION
        SELECT code, pollution_score AS score FROM air_pollution
        UNION
        SELECT code, en_score AS score FROM energy
        UNION
        SELECT Country_code as code, Plastic_Pollution_Score as score FROM plastic_pollution
    ) AS merged_topics
    GROUP BY code
) AS aggregated ON population.code = aggregated.code;