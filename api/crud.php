<?php
require_once __DIR__ . '/config.php';

// Validación de tablas y campos para evitar inyección SQL
function validarEstructuraDB($tabla, $campo = null) {
    $esquema = [
        "modelos" => ["ID_Modelo", "Marca", "Modelo", "Categoria", "Fecha_produccion", "Fin_soporte", "Especificaciones"],
        "activos" => ["ID_Activo", "N_Serial", "ID_Modelo", "Estado", "Nombre", "Fecha_compra", "Garantia", "Modificado", "Observaciones"],
        "asignaciones" => ["ID_Asignacion", "Identificador", "Fecha_Asignacion", "Ultimo_Soporte", "ID_Activo"],
        "categorias" => ["ID_Categoria", "Nombre"]
    ];
    if (!array_key_exists($tabla, $esquema)) return false;
    if ($campo !== null && !in_array($campo, $esquema[$tabla])) return false;
    return true;
}

function obtenerPK($tabla) {
    $pks = ["modelos" => "ID_Modelo", "activos" => "ID_Activo", "asignaciones" => "ID_Asignacion"];
    return $pks[$tabla] ?? null;
}

// --- CONSULTAS (READ) ---
function obtenerTodo($tabla) {
    global $pdo;
    if (!validarEstructuraDB($tabla)) return [];
    $stmt = $pdo->query("SELECT * FROM `$tabla` ORDER BY 1 ASC");
    return $stmt->fetchAll();
}

function obtenerRegistroPorId($tabla, $id) {
    global $pdo;
    $campoId = obtenerPK($tabla);
    if (!$campoId) return null;
    $stmt = $pdo->prepare("SELECT * FROM `$tabla` WHERE `$campoId` = ?");
    $stmt->execute([$id]);
    return $stmt->fetch() ?: null;
}

function obtenerListaPorCampo($tabla, $campo, $valor) {
    global $pdo;
    if (!validarEstructuraDB($tabla, $campo)) return [];
    $stmt = $pdo->prepare("SELECT * FROM `$tabla` WHERE `$campo` = ?");
    $stmt->execute([$valor]);
    return $stmt->fetchAll();
}

// --- ESCRITURA (CREATE, UPDATE, DELETE) ---
function crearRegistro($tabla, $datos) {
    global $pdo;
    if (!validarEstructuraDB($tabla)) return false;
    $campos = array_keys($datos);
    $placeholders = array_fill(0, count($campos), '?');
    $sql = "INSERT INTO `$tabla` (" . implode(", ", $campos) . ") VALUES (" . implode(", ", $placeholders) . ")";
    try {
        $stmt = $pdo->prepare($sql);
        $stmt->execute(array_values($datos));
        return $pdo->lastInsertId();
    } catch (PDOException $e) { return false; }
}

function actualizarRegistro($tabla, $id, $datos) {
    global $pdo;
    $campoId = obtenerPK($tabla);
    if (!$campoId || !validarEstructuraDB($tabla)) return false;
    $sets = []; $valores = [];
    foreach ($datos as $campo => $valor) {
        if (validarEstructuraDB($tabla, $campo)) {
            $sets[] = "`$campo` = ?";
            $valores[] = $valor;
        }
    }
    if (empty($sets)) return false;
    $valores[] = $id;
    $sql = "UPDATE `$tabla` SET " . implode(", ", $sets) . " WHERE `$campoId` = ?";
    try {
        $stmt = $pdo->prepare($sql);
        $stmt->execute($valores);
        return true;
    } catch (PDOException $e) { return false; }
}

function borrarPorID($tabla, $id) {
    global $pdo;
    $campoId = obtenerPK($tabla);
    if (!$campoId) return false;
    $stmt = $pdo->prepare("DELETE FROM `$tabla` WHERE `$campoId` = ?");
    $stmt->execute([$id]);
    return $stmt->rowCount() > 0;
}
?>