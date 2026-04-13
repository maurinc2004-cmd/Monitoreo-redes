create database IF NOT exists Inventario_tecnologia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
show databases;

use inventario_tecnologia;

DROP TABLE IF EXISTS Modelos;
create table Modelos (
ID_Modelo int primary key auto_increment,
Marca varchar(50),
Modelo varchar(50),
Categoria varchar(50),
Fecha_produccion smallint(2),
Fin_soporte date,
Especificaciones varchar(255)

);
DROP TABLE IF EXISTS Activos;
create table Activos (
ID_Activo int primary key auto_increment,
N_Serial varchar(50) unique,
ID_Modelo int,
Estado VARCHAR(20) DEFAULT 'Disponible',/*Disponible, Asignado, En reparación, En Espera, De baja*/
Nombre varchar(50),
Fecha_compra date,
Garantia date, /*fecha de vencimiento de la garantia del fabriacante o proveedor*/
Modificado boolean,
Observaciones varchar(255),

FOREIGN key (ID_Modelo) references Modelos(ID_Modelo)
);

drop table if exists Asignaciones;
create table Asignaciones(
ID_Asignacion int primary key auto_increment,
Identificador varchar(50),
Fecha_Asignacion date,
Ultimo_Soporte date,
ID_Activo int unique not null,
foreign key (ID_Activo) references Activos(ID_Activo)
);

show tables;

DELIMITER //

CREATE TRIGGER tr_activo_asignado
AFTER INSERT ON Asignaciones
FOR EACH ROW
BEGIN
    UPDATE Activos 
    SET Estado = 'Asignado' 
    WHERE ID_Activo = NEW.ID_Activo;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER tr_activo_disponible
AFTER DELETE ON Asignaciones
FOR EACH ROW
BEGIN
    UPDATE Activos 
    SET Estado = 'Disponible' 
    WHERE ID_Activo = OLD.ID_Activo;
END //

DELIMITER ;