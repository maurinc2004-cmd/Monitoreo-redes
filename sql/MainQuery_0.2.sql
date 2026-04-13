-- MySQL Workbench Forward Engineering corregido para MariaDB/MySQL

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

-- -----------------------------------------------------
-- Schema inventario_tecnologia
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `inventario_tecnologia` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `inventario_tecnologia`;

-- -----------------------------------------------------
-- Table `modelos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelos` (
  `ID_Modelo` INT(11) NOT NULL AUTO_INCREMENT,
  `Marca` VARCHAR(50) NULL DEFAULT NULL,
  `Modelo` VARCHAR(50) NULL DEFAULT NULL,
  `Categoria` VARCHAR(50) NULL DEFAULT NULL,
  `Fecha_produccion` SMALLINT(2) NULL DEFAULT NULL,
  `Fin_soporte` DATE NULL DEFAULT NULL,
  `Especificaciones` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`ID_Modelo`)
) ENGINE = InnoDB AUTO_INCREMENT = 1;

-- -----------------------------------------------------
-- Table `Caracteristicas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Categorias` (
  `ID_Categoria` INT(11) NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(50) NULL,
  
  PRIMARY KEY (`ID_Categoria`)
) ENGINE = InnoDB AUTO_INCREMENT = 1;

-- -----------------------------------------------------
-- Table `activos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `activos` (
  `ID_Activo` INT(11) NOT NULL AUTO_INCREMENT,
  `N_Serial` VARCHAR(50) NULL DEFAULT NULL,
  `ID_Modelo` INT(11) NULL DEFAULT NULL,
  `Estado` VARCHAR(20) NULL DEFAULT 'Disponible',
  `Nombre` VARCHAR(50) NULL DEFAULT NULL,
  `Fecha_compra` DATE NULL DEFAULT NULL,
  `Garantia` DATE NULL DEFAULT NULL,
  `Modificado` TINYINT(1) NULL DEFAULT NULL,
  `Observaciones` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`ID_Activo`),
  UNIQUE INDEX `N_Serial_UNIQUE` (`N_Serial` ASC),
  INDEX `ID_Modelo_idx` (`ID_Modelo` ASC),
  CONSTRAINT `modelx`
    FOREIGN KEY (`ID_Modelo`)
    REFERENCES `modelos` (`ID_Modelo`)
) ENGINE = InnoDB AUTO_INCREMENT = 1;

-- -----------------------------------------------------
-- Table `asignaciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `asignaciones` (
  `ID_Asignacion` INT(11) NOT NULL AUTO_INCREMENT,
  `ID_empleado` VARCHAR(50) NULL DEFAULT NULL,
  `Fecha_Asignacion` DATE NULL DEFAULT NULL,
  `Ultimo_Soporte` DATE NULL DEFAULT NULL,
  `ID_Activo` INT(11) NOT NULL,
  PRIMARY KEY (`ID_Asignacion`),
  UNIQUE INDEX `ID_Activo_UNIQUE` (`ID_Activo` ASC),
  CONSTRAINT `asignaciones_ibfk_1`
    FOREIGN KEY (`ID_Activo`)
    REFERENCES `activos` (`ID_Activo`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuarios` (
  `Cedula` INT NOT NULL,
  `Email` VARCHAR(50) NULL,
  `Nombre` VARCHAR(50) NULL,
  `Cargo` VARCHAR(50) NULL,
  `Last_Login` DATE NULL,
  `Password_Hash` VARCHAR(255) NULL,
  `Is_Active` TINYINT NULL,
  PRIMARY KEY (`Cedula`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Ordenes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordenes` (
  `ID_Orden` INT NOT NULL AUTO_INCREMENT,
  `Fecha_Creacion` DATE NULL,
  `Estado` VARCHAR(20) NULL,
  `ID_Activo` INT NULL,
  `Tecnico` INT NULL,
  PRIMARY KEY (`ID_Orden`),
  INDEX `ID_Activo_idx` (`ID_Activo` ASC),
  INDEX `tecnico_idx` (`Tecnico` ASC),
  CONSTRAINT `fk_activo_orden`
    FOREIGN KEY (`ID_Activo`)
    REFERENCES `activos` (`ID_Activo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_tecnico_orden`
    FOREIGN KEY (`Tecnico`)
    REFERENCES `usuarios` (`Cedula`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `historial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `historial` (
  `ID_Registro` INT NOT NULL AUTO_INCREMENT,
  `ID_Activo` INT NULL,
  `ID_Modelo` INT NULL,
  `Fecha_Creacion` DATE NULL,
  `Fecha_Cierre` DATE NULL,
  `Falla` JSON NULL,
  PRIMARY KEY (`ID_Registro`),
  INDEX `activo_idx` (`ID_Activo` ASC),
  INDEX `model_idx` (`ID_Modelo` ASC),
  CONSTRAINT `fk_activo_hist`
    FOREIGN KEY (`ID_Activo`)
    REFERENCES `activos` (`ID_Activo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_model_hist`
    FOREIGN KEY (`ID_Modelo`)
    REFERENCES `modelos` (`ID_Modelo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;