<?php
// Configuración de la base de datos basada en MainQuery.sql
$host = "localhost";
$db_name = "inventario_tecnologia";
$username = "root";
$password = ""; // Cambia esto si tienes contraseña en tu servidor local
$charset = "utf8mb4";

$db_inventario = [
    "host" => "localhost",
    "db_name" => "inventario_tecnologia",
    "username" => "root",
    "password" => "",
    "charset" => "utf8mb4"
];

$db_intranet = [
    "host" => "localhost",
    "db_name" => "intranetdb",
    "username" => "root",
    "password" => "",
    "charset" => "utf8mb4"
];

$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    // Conexión 1: Inventario
    $dsn_inv = "mysql:host={$db_inventario['host']};dbname={$db_inventario['db_name']};charset={$db_inventario['charset']}";
    $pdo = new PDO($dsn_inv, $db_inventario['username'], $db_inventario['password'], $options);

    // Conexión 2: Intranet
    $dsn_int = "mysql:host={$db_intranet['host']};dbname={$db_intranet['db_name']};charset={$db_intranet['charset']}";
    $pdo_int = new PDO($dsn_int, $db_intranet['username'], $db_intranet['password'], $options);
    // Conexión exitosa
} catch (\PDOException $e) {
    throw new \PDOException($e->getMessage(), (int)$e->getCode());
}
