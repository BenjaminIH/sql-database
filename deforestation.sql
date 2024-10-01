SET
    GLOBAL local_infile = 1;

CREATE DATABASE IF NOT EXISTS business_trips;

USE business_trips;

DROP TABLE IF EXISTS populations;

DROP TABLE IF EXISTS deforestation;

CREATE TABLE populations (
    `id` INT NOT NULL AUTO_INCREMENT,
    `country` VARCHAR(45) NOT NULL,
    `code` VARCHAR(8) NOT NULL,
    `year` VARCHAR(4) NOT NULL,
    `population` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE deforestation (
    `id` INT NOT NULL AUTO_INCREMENT,
    `country` VARCHAR(45) NOT NULL,
    `code` VARCHAR(8) NOT NULL,
    `year` VARCHAR(4) NOT NULL,
    `imported_deforestation` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`id`)
);

LOAD DATA LOCAL INFILE '/Users/jpl/Class/Quests/sql-database/sources/clean/imported-deforestation-clean.csv' INTO TABLE deforestation FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (country, code, year, imported_deforestation);

LOAD DATA LOCAL INFILE '/Users/jpl/Class/Quests/sql-database/sources/clean/population-clean.csv' INTO TABLE populations FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (country, code, year, population);