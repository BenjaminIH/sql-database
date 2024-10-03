USE business_trips_db;

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
        SELECT code, pollution_score FROM air_pollution
        UNION
        SELECT code, en_score FROM energy
        UNION
        SELECT Country_code, Plastic_Pollution_Score FROM plastic_pollution
    ) AS combined_scores
    GROUP BY code
) AS aggregated ON population.code = aggregated.code;