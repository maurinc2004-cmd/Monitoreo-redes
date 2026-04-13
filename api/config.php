<?php
// ============================================================
// Configuración de la Base de Datos - Sistema de Monitoreo LAN
// Basado en la arquitectura del proyecto inventarioSH
// ============================================================

$db_config = [
    "host"     => "localhost",
    "db_name"  => "monitoreo_red_lan",
    "username" => "root",
    "password" => "", // Cambia si tienes contraseña
    "charset"  => "utf8mb4"
];

$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $dsn = "mysql:host={$db_config['host']};dbname={$db_config['db_name']};charset={$db_config['charset']}";
    $pdo = new PDO($dsn, $db_config['username'], $db_config['password'], $options);
} catch (\PDOException $e) {
    http_response_code(503);
    echo json_encode(["error" => "Error de conexión a la base de datos: " . $e->getMessage()]);
    exit;
}
