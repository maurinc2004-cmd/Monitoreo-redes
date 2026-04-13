-- ============================================================
-- SISTEMA DE MONITOREO DE RED LAN
-- Base de Datos Centralizada para los 3 Módulos
-- Alumno: Mauricio Niño
-- ============================================================

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

CREATE SCHEMA IF NOT EXISTS `monitoreo_red_lan` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `monitoreo_red_lan`;

-- ============================================================
-- MÓDULO 1: Conectar Equipos, Información, Organización y Transmisión
-- ============================================================

-- Tabla de equipos conectados a la red LAN
CREATE TABLE IF NOT EXISTS `equipos` (
  `ID_Equipo`       INT(11) NOT NULL AUTO_INCREMENT,
  `Nombre`          VARCHAR(100) NOT NULL,
  `IP`              VARCHAR(20)  NOT NULL,
  `MAC`             VARCHAR(20)  NOT NULL,
  `Tipo`            VARCHAR(50)  NULL DEFAULT 'Workstation', -- PC, Servidor, Router, Switch, Impresora, etc.
  `Sistema_Operativo` VARCHAR(80) NULL,
  `Departamento`    VARCHAR(80)  NULL,
  `Responsable`     VARCHAR(100) NULL,
  `Estado`          VARCHAR(20)  NOT NULL DEFAULT 'Activo', -- Activo, Inactivo, En_Falla
  `Fecha_Registro`  DATETIME     DEFAULT CURRENT_TIMESTAMP,
  `Ultima_Conexion` DATETIME     NULL,
  `Descripcion`     VARCHAR(255) NULL,
  PRIMARY KEY (`ID_Equipo`),
  UNIQUE INDEX `IP_UNIQUE` (`IP` ASC),
  UNIQUE INDEX `MAC_UNIQUE` (`MAC` ASC)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- Categorías de equipos
CREATE TABLE IF NOT EXISTS `categorias_equipo` (
  `ID_Categoria`  INT(11) NOT NULL AUTO_INCREMENT,
  `Nombre`        VARCHAR(80) NOT NULL,
  `Descripcion`   VARCHAR(255) NULL,
  PRIMARY KEY (`ID_Categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- Registro de transmisiones (logs de tráfico entre equipos)
CREATE TABLE IF NOT EXISTS `transmisiones` (
  `ID_Transmision`  INT(11) NOT NULL AUTO_INCREMENT,
  `ID_Equipo_Origen` INT(11) NOT NULL,
  `IP_Destino`      VARCHAR(20) NOT NULL,
  `Puerto`          INT(6)     NULL,
  `Protocolo`       VARCHAR(10) NULL DEFAULT 'TCP', -- TCP, UDP, ICMP
  `Bytes_Enviados`  BIGINT      NULL DEFAULT 0,
  `Bytes_Recibidos` BIGINT      NULL DEFAULT 0,
  `Fecha`           DATETIME    DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_Transmision`),
  INDEX `equipo_idx` (`ID_Equipo_Origen` ASC),
  CONSTRAINT `fk_transm_equipo` FOREIGN KEY (`ID_Equipo_Origen`) REFERENCES `equipos` (`ID_Equipo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- ============================================================
-- MÓDULO 2: Seguridad de Red
-- ============================================================

-- Registros del firewall (entrada/salida de tráfico)
CREATE TABLE IF NOT EXISTS `firewall_logs` (
  `ID_Log`        INT(11) NOT NULL AUTO_INCREMENT,
  `IP_Origen`     VARCHAR(20) NOT NULL,
  `IP_Destino`    VARCHAR(20) NOT NULL,
  `Puerto`        INT(6)      NULL,
  `Protocolo`     VARCHAR(10) NULL,
  `Accion`        VARCHAR(20) NOT NULL DEFAULT 'ALLOW', -- ALLOW, BLOCK, DROP
  `Direccion`     VARCHAR(10) NOT NULL DEFAULT 'IN', -- IN, OUT
  `Motivo`        VARCHAR(255) NULL,
  `Fecha`         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_Log`),
  INDEX `ip_origen_idx` (`IP_Origen` ASC)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- Amenazas detectadas (malware, intrusiones)
CREATE TABLE IF NOT EXISTS `amenazas` (
  `ID_Amenaza`    INT(11) NOT NULL AUTO_INCREMENT,
  `ID_Equipo`     INT(11) NULL,
  `IP_Origen`     VARCHAR(20) NULL,
  `Tipo`          VARCHAR(80) NOT NULL, -- Malware, Intrusion, PortScan, BruteForce, etc.
  `Severidad`     VARCHAR(20) NOT NULL DEFAULT 'Media', -- Baja, Media, Alta, Crítica
  `Descripcion`   VARCHAR(500) NULL,
  `Estado`        VARCHAR(20) NOT NULL DEFAULT 'Activa', -- Activa, Mitigada, Ignorada
  `Fecha`         DATETIME DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Mitigacion` DATETIME NULL,
  PRIMARY KEY (`ID_Amenaza`),
  INDEX `equipo_idx` (`ID_Equipo` ASC),
  CONSTRAINT `fk_amenaza_equipo` FOREIGN KEY (`ID_Equipo`) REFERENCES `equipos` (`ID_Equipo`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- Reglas del proxy y DNS
CREATE TABLE IF NOT EXISTS `reglas_proxy` (
  `ID_Regla`      INT(11) NOT NULL AUTO_INCREMENT,
  `Dominio`       VARCHAR(255) NOT NULL,
  `Accion`        VARCHAR(20) NOT NULL DEFAULT 'BLOCK', -- BLOCK, ALLOW, REDIRECT
  `Categoria`     VARCHAR(80) NULL, -- Malware, Adultos, Redes_Sociales, etc.
  `Activa`        TINYINT(1) NOT NULL DEFAULT 1,
  `Fecha_Creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_Regla`),
  UNIQUE INDEX `dominio_UNIQUE` (`Dominio` ASC)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- Sesiones de administrador
CREATE TABLE IF NOT EXISTS `sesiones_admin` (
  `ID_Sesion`   INT(11) NOT NULL AUTO_INCREMENT,
  `Cedula`      INT NOT NULL,
  `IP_Acceso`   VARCHAR(20) NULL,
  `Inicio`      DATETIME DEFAULT CURRENT_TIMESTAMP,
  `Fin`         DATETIME NULL,
  `Activa`      TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID_Sesion`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- ============================================================
-- MÓDULO 3: Monitoreo de Archivos y Gestor FTP
-- ============================================================

-- Archivos que llegan a los equipos vía red
CREATE TABLE IF NOT EXISTS `archivos_monitoreados` (
  `ID_Archivo`    INT(11) NOT NULL AUTO_INCREMENT,
  `Nombre`        VARCHAR(255) NOT NULL,
  `Extension`     VARCHAR(20) NULL,
  `Tamano_Bytes`  BIGINT NULL,
  `Hash_MD5`      VARCHAR(64) NULL,
  `IP_Origen`     VARCHAR(20) NULL,
  `IP_Destino`    VARCHAR(20) NULL,
  `ID_Equipo`     INT(11) NULL,
  `Ruta`          VARCHAR(500) NULL,
  `Estado`        VARCHAR(20) NOT NULL DEFAULT 'Limpio', -- Limpio, Sospechoso, Bloqueado, En_Cuarentena
  `Fecha`         DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_Archivo`),
  INDEX `equipo_idx` (`ID_Equipo` ASC),
  CONSTRAINT `fk_archivo_equipo` FOREIGN KEY (`ID_Equipo`) REFERENCES `equipos` (`ID_Equipo`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- Transferencias FTP entre cliente y servidor
CREATE TABLE IF NOT EXISTS `transferencias_ftp` (
  `ID_Transferencia` INT(11) NOT NULL AUTO_INCREMENT,
  `ID_Archivo`       INT(11) NULL,
  `Tipo`             VARCHAR(10) NOT NULL DEFAULT 'UPLOAD', -- UPLOAD, DOWNLOAD
  `IP_Cliente`       VARCHAR(20) NOT NULL,
  `IP_Servidor`      VARCHAR(20) NOT NULL,
  `Puerto`           INT(6) DEFAULT 21,
  `Estado`           VARCHAR(20) NOT NULL DEFAULT 'Completado', -- Completado, Fallido, Cancelado, En_Progreso
  `Bytes_Transferidos` BIGINT NULL DEFAULT 0,
  `Fecha`            DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_Transferencia`),
  INDEX `archivo_idx` (`ID_Archivo` ASC),
  CONSTRAINT `fk_ftp_archivo` FOREIGN KEY (`ID_Archivo`) REFERENCES `archivos_monitoreados` (`ID_Archivo`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- ============================================================
-- TABLA DE USUARIOS (Administrador + Soporte Técnico)
-- ============================================================
CREATE TABLE IF NOT EXISTS `usuarios` (
  `Cedula`         INT NOT NULL,
  `Nombre`         VARCHAR(100) NOT NULL,
  `Email`          VARCHAR(100) NULL,
  `Cargo`          VARCHAR(80) NULL DEFAULT 'Soporte', -- Administrador, Soporte, JefeDpto
  `Password_Hash`  VARCHAR(255) NOT NULL,
  `Is_Active`      TINYINT(1) NOT NULL DEFAULT 1,
  `Last_Login`     DATETIME NULL,
  PRIMARY KEY (`Cedula`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC)
) ENGINE=InnoDB;

-- ============================================================
-- DATOS DE PRUEBA (SEED DATA)
-- ============================================================

INSERT INTO `usuarios` (`Cedula`, `Nombre`, `Email`, `Cargo`, `Password_Hash`, `Is_Active`) VALUES
(10001, 'Administrador Principal', 'admin@red.local', 'Administrador', SHA2('Admin123!', 256), 1),
(10002, 'Mauricio Niño', 'mauricio@red.local', 'JefeDpto', SHA2('Soporte456!', 256), 1),
(10003, 'Soporte Técnico', 'soporte@red.local', 'Soporte', SHA2('Tech789!', 256), 1);

INSERT INTO `categorias_equipo` (`Nombre`, `Descripcion`) VALUES
('Workstation', 'Estaciones de trabajo de los usuarios'),
('Servidor', 'Servidores de archivos, aplicaciones y datos'),
('Dispositivo de Red', 'Routers, Switches, Access Points'),
('Impresora', 'Dispositivos de impresión en red'),
('Cámara IP', 'Cámaras de vigilancia conectadas');

INSERT INTO `equipos` (`Nombre`, `IP`, `MAC`, `Tipo`, `Sistema_Operativo`, `Departamento`, `Responsable`, `Estado`) VALUES
('PC-Admin-01', '192.168.1.1', 'AA:BB:CC:DD:EE:01', 'Workstation', 'Windows 11 Pro', 'Administración', 'Administrador Principal', 'Activo'),
('SRV-Files-01', '192.168.1.10', 'AA:BB:CC:DD:EE:10', 'Servidor', 'Ubuntu Server 22.04', 'Infraestructura', 'Soporte Técnico', 'Activo'),
('RT-CORE-01', '192.168.1.254', 'AA:BB:CC:DD:EE:FE', 'Dispositivo de Red', 'RouterOS 7.x', 'Infraestructura', 'Administrador Principal', 'Activo'),
('PC-RRHH-01', '192.168.1.50', 'AA:BB:CC:DD:EE:50', 'Workstation', 'Windows 10 Pro', 'Recursos Humanos', 'Mauricio Niño', 'Activo'),
('PC-RRHH-02', '192.168.1.51', 'AA:BB:CC:DD:EE:51', 'Workstation', 'Windows 10 Pro', 'Recursos Humanos', 'Mauricio Niño', 'Inactivo'),
('IMPRESORA-01', '192.168.1.100', 'AA:BB:CC:DD:EE:C8', 'Impresora', 'Embedded', 'Administración', 'Administrador Principal', 'Activo');

INSERT INTO `reglas_proxy` (`Dominio`, `Accion`, `Categoria`, `Activa`) VALUES
('pornhub.com', 'BLOCK', 'Adultos', 1),
('malwaresite.ru', 'BLOCK', 'Malware', 1),
('facebook.com', 'BLOCK', 'Redes_Sociales', 1),
('youtube.com', 'ALLOW', 'Entretenimiento', 1),
('google.com', 'ALLOW', 'Motor_Busqueda', 1),
('virustotal.com', 'ALLOW', 'Seguridad', 1);

INSERT INTO `firewall_logs` (`IP_Origen`, `IP_Destino`, `Puerto`, `Protocolo`, `Accion`, `Direccion`, `Motivo`) VALUES
('192.168.1.50', '8.8.8.8', 53, 'UDP', 'ALLOW', 'OUT', 'Consulta DNS'),
('185.99.132.20', '192.168.1.10', 22, 'TCP', 'BLOCK', 'IN', 'Intento SSH externo bloqueado'),
('192.168.1.1', '192.168.1.254', 80, 'TCP', 'ALLOW', 'OUT', 'Acceso HTTP interno'),
('203.0.113.5', '192.168.1.10', 21, 'TCP', 'BLOCK', 'IN', 'Intento FTP externo');

INSERT INTO `amenazas` (`ID_Equipo`, `IP_Origen`, `Tipo`, `Severidad`, `Descripcion`, `Estado`) VALUES
(4, '192.168.1.50', 'PortScan', 'Media', 'Escaneo de puertos detectado desde PC-RRHH-01', 'Activa'),
(NULL, '185.99.132.20', 'BruteForce', 'Alta', 'Intento de fuerza bruta SSH desde IP externa', 'Mitigada'),
(2, '192.168.1.10', 'Malware', 'Crítica', 'Archivo sospechoso detectado en SRV-Files-01', 'Activa');

INSERT INTO `archivos_monitoreados` (`Nombre`, `Extension`, `Tamano_Bytes`, `Hash_MD5`, `IP_Origen`, `IP_Destino`, `ID_Equipo`, `Ruta`, `Estado`) VALUES
('reporte_mensual.pdf', 'pdf', 204800, 'a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4', '192.168.1.50', '192.168.1.10', 2, '/srv/archivos/reportes/', 'Limpio'),
('setup_crack.exe', 'exe', 5120000, 'DEADBEEF1234567890ABCDEF00112233', '192.168.1.51', '192.168.1.10', 2, '/srv/archivos/temp/', 'Bloqueado'),
('nomina_abril.xlsx', 'xlsx', 102400, 'b2c3d4e5f6a7b2c3d4e5f6a7b2c3d4e5', '192.168.1.50', '192.168.1.10', 2, '/srv/archivos/rrhh/', 'Limpio');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
