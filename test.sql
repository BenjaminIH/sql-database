DROP TABLE IF EXISTS population;

DROP TABLE IF EXISTS deforestation;

CREATE TABLE population (
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