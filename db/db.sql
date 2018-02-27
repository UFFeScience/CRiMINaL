-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema ccd-bd
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ccd-bd
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ccd-bd` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `ccd-bd` ;

-- -----------------------------------------------------
-- Table `ccd-bd`.`Occurrence_Conv`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccd-bd`.`Occurrence_Conv` (
  `idOccurrence_Bin` INT UNSIGNED NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `title` VARCHAR(70) NOT NULL,
  `latitude` DOUBLE NOT NULL,
  `longitude` DOUBLE NOT NULL,
  `date_time` DATETIME NOT NULL,
  `description` VARCHAR(350) NULL,
  `stolen` INT ZEROFILL UNSIGNED NOT NULL,
  PRIMARY KEY (`idOccurrence_Bin`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = big5
COLLATE = big5_bin;


-- -----------------------------------------------------
-- Table `ccd-bd`.`Occurrence_Multi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccd-bd`.`Occurrence_Multi` (
  `idOccurrence_Multi` INT UNSIGNED NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `title` VARCHAR(70) NOT NULL,
  `latitude` DOUBLE NOT NULL,
  `longitude` DOUBLE NOT NULL,
  `date_time` DATETIME NOT NULL,
  `description` VARCHAR(350) NULL,
  PRIMARY KEY (`idOccurrence_Multi`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ccd-bd`.`Objects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccd-bd`.`Objects` (
  `idObjects` INT NOT NULL,
  `idOccurrence_Multi` INT NOT NULL,
  `object` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idObjects`),
  CONSTRAINT `idOccurrence_Multi`
    FOREIGN KEY ()
    REFERENCES `ccd-bd`.`Occurrence_Multi` ()
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ccd-bd`.`Occurrence_Bin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccd-bd`.`Occurrence_Bin` (
  `idOccurrence_Bin` INT UNSIGNED NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `title` VARCHAR(70) NOT NULL,
  `latitude` DOUBLE NOT NULL,
  `longitude` DOUBLE NOT NULL,
  `date_time` DATETIME NOT NULL,
  `description` VARCHAR(350) NULL,
  `object_1` TINYINT(1) NULL,
  `object_2` TINYINT(1) NULL,
  `object_3` TINYINT(1) NULL,
  `object_4` TINYINT(1) NULL,
  `object_5` TINYINT(1) NULL,
  `object_6` TINYINT(1) NULL,
  `object_7` TINYINT(1) NULL,
  `object_8` TINYINT(1) NULL,
  `object_9` TINYINT(1) NULL,
  `object_10` TINYINT(1) NULL,
  `object_11` TINYINT(1) NULL,
  `object_12` TINYINT(1) NULL,
  `object_13` TINYINT(1) NULL,
  `object_14` TINYINT(1) NULL,
  `object_15` TINYINT(1) NULL,
  `object_16` TINYINT(1) NULL,
  `object_17` TINYINT(1) NULL,
  `object_18` TINYINT(1) NULL,
  `object_19` TINYINT(1) NULL,
  PRIMARY KEY (`idOccurrence_Bin`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
