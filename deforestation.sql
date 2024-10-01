SET
    GLOBAL local_infile = 1;

CREATE DATABASE IF NOT EXISTS business_trips;

USE business_trips;

DROP TABLE IF EXISTS populations;

DROP TABLE IF EXISTS deforestation;

CREATE TABLE populations (
    `country` VARCHAR(45) NOT NULL,
    `code` VARCHAR(8) NOT NULL,
    `year` VARCHAR(4) NOT NULL,
    `population` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`code`)
);

CREATE TABLE deforestation (
    `country` VARCHAR(45) NOT NULL,
    `code` VARCHAR(8) NOT NULL,
    `year` VARCHAR(4) NOT NULL,
    `imported_deforestation` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`code`)
);

LOAD DATA LOCAL INFILE '/Users/jpl/Class/Quests/sql-database/sources/clean/imported-deforestation-clean.csv' INTO TABLE deforestation FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (country, code, year, imported_deforestation);

LOAD DATA LOCAL INFILE '/Users/jpl/Class/Quests/sql-database/sources/clean/population-clean.csv' INTO TABLE populations FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (country, code, year, population);

SELECT
    country,
    code,
    year,
    imported_deforestation,
    ROUND(
        1 + ((imported_deforestation - sub.X_min) * 9) / (sub.X_max - sub.X_min)
    ) AS score
FROM
    deforestation,
    (
        SELECT
            MIN(imported_deforestation) AS X_min,
            MAX(imported_deforestation) AS X_max
        FROM
            deforestation
    ) sub;