drop database if exists inventario_tecnologia;
show databases;

use inventario_tecnologia;

show tables;

INSERT INTO `categorias` ( `Nombre`) VALUES ('Laptop');
INSERT INTO `categorias` ( `Nombre`) VALUES ('Desktop');
INSERT INTO `categorias` ( `Nombre`) VALUES ('Servidor');
INSERT INTO `categorias` ( `Nombre`) VALUES ('Impresora');
INSERT INTO `categorias` ( `Nombre`) VALUES ('Monitor');

select * from categorias;

USE `inventario_tecnologia`;

INSERT INTO `modelos` (`Marca`, `Modelo`, `Categoria`, `Fecha_produccion`, `Fin_soporte`, `Especificaciones`) VALUES
('Dell', 'Latitude 5420', 'Laptop', 2021, '2026-12-31', 'i5-1145G7, 16GB RAM, 512GB SSD'),
('Dell', 'OptiPlex 7080', 'Desktop', 2020, '2025-06-15', 'i7-10700, 8GB RAM, 256GB SSD'),
('HP', 'EliteBook 840 G8', 'Laptop', 2021, '2027-01-20', 'i7-1165G7, 16GB RAM, 1TB SSD'),
('HP', 'ProDesk 600 G6', 'Desktop', 2020, '2025-11-30', 'i5-10500, 16GB RAM, 512GB SSD'),
('Lenovo', 'ThinkPad X1 Carbon Gen 9', 'Laptop', 2021, '2028-03-10', 'i7-1185G7, 32GB RAM, 1TB SSD'),
('Lenovo', 'ThinkCentre M70q', 'Mini PC', 2021, '2026-08-22', 'i5-11400T, 16GB RAM, 512GB SSD'),
('Apple', 'MacBook Pro M1', 'Laptop', 2020, '2027-11-01', 'M1 Chip, 16GB RAM, 512GB SSD'),
('Apple', 'Mac Studio', 'Workstation', 2022, '2029-05-05', 'M1 Max, 32GB RAM, 1TB SSD'),
('Cisco', 'Catalyst 9200L', 'Switch', 2019, '2024-12-31', '24 Ports PoE+, Stackable'),
('Cisco', 'C9200L-48T-4G', 'Switch', 2020, '2025-10-15', '48 Ports Data, 4x1G Uplinks'),
('Logitech', 'MX Master 3', 'Periferico', 2019, '2023-12-31', 'Mouse Inalámbrico, Bluetooth/Unifying'),
('Logitech', 'K800', 'Periferico', 2018, '2023-01-01', 'Teclado Retroiluminado Inalámbrico'),
('Samsung', 'Odyssey G5', 'Monitor', 2021, '2026-06-30', '27-inch, 144Hz, QHD Curved'),
('LG', '27UK850-W', 'Monitor', 2020, '2025-04-12', '27-inch 4K UHD IPS con USB-C'),
('Ubiquiti', 'UniFi AP-AC-Pro', 'Networking', 2018, '2024-02-28', '802.11ac Dual-Band Access Point'),
('Synology', 'DS920+', 'Storage', 2020, '2026-09-15', '4-Bay NAS, Celeron J4125, 4GB RAM'),
('Epson', 'EcoTank L3250', 'Impresora', 2021, '2026-01-20', 'Multifuncional WiFi InkTank'),
('Zebra', 'ZT230', 'Impresora', 2019, '2025-08-30', 'Industrial Label Printer, Térmica'),
('Fortinet', 'FortiGate 60F', 'Firewall', 2020, '2027-05-15', 'Next-Generation Firewall'),
('APC', 'Smart-UPS 1500VA', 'Energia', 2021, '2028-12-31', 'LCD 120V con SmartConnect');
select * from modelos;
select * from modelos order by 1 asc;