<?php
// ============================================================
// crud.php - Capa de acceso a datos (CRUD Genérico + Seguro)
// Patrón idéntico al de inventarioSH, adaptado para monitoreo_red_lan
// ============================================================
require_once __DIR__ . '/config.php';

// Mapeo de tablas y campos permitidos (protección contra SQL Injection)
function validarEstructuraDB($tabla, $campo = null) {
    $esquema = [
        "equipos"               => ["ID_Equipo", "Nombre", "IP", "MAC", "Tipo", "Sistema_Operativo", "Departamento", "Responsable", "Estado", "Fecha_Registro", "Ultima_Conexion", "Descripcion"],
        "categorias_equipo"     => ["ID_Categoria", "Nombre", "Descripcion"],
        "transmisiones"         => ["ID_Transmision", "ID_Equipo_Origen", "IP_Destino", "Puerto", "Protocolo", "Bytes_Enviados", "Bytes_Recibidos", "Fecha"],
        "firewall_logs"         => ["ID_Log", "IP_Origen", "IP_Destino", "Puerto", "Protocolo", "Accion", "Direccion", "Motivo", "Fecha"],
        "amenazas"              => ["ID_Amenaza", "ID_Equipo", "IP_Origen", "Tipo", "Severidad", "Descripcion", "Estado", "Fecha", "Fecha_Mitigacion"],
        "reglas_proxy"          => ["ID_Regla", "Dominio", "Accion", "Categoria", "Activa", "Fecha_Creacion"],
        "sesiones_admin"        => ["ID_Sesion", "Cedula", "IP_Acceso", "Inicio", "Fin", "Activa"],
        "archivos_monitoreados" => ["ID_Archivo", "Nombre", "Extension", "Tamano_Bytes", "Hash_MD5", "IP_Origen", "IP_Destino", "ID_Equipo", "Ruta", "Estado", "Fecha"],
        "transferencias_ftp"    => ["ID_Transferencia", "ID_Archivo", "Tipo", "IP_Cliente", "IP_Servidor", "Puerto", "Estado", "Bytes_Transferidos", "Fecha"],
        "usuarios"              => ["Cedula", "Nombre", "Email", "Cargo", "Is_Active", "Last_Login"]
    ];

    if (!array_key_exists($tabla, $esquema)) return false;
    if ($campo !== null && !in_array($campo, $esquema[$tabla])) return false;
    return true;
}

function obtenerPK($tabla) {
    $pks = [
        "equipos"               => "ID_Equipo",
        "categorias_equipo"     => "ID_Categoria",
        "transmisiones"         => "ID_Transmision",
        "firewall_logs"         => "ID_Log",
        "amenazas"              => "ID_Amenaza",
        "reglas_proxy"          => "ID_Regla",
        "sesiones_admin"        => "ID_Sesion",
        "archivos_monitoreados" => "ID_Archivo",
        "transferencias_ftp"    => "ID_Transferencia",
        "usuarios"              => "Cedula"
    ];
    return $pks[$tabla] ?? null;
}

// --- CONSULTAS (READ) ---
function obtenerTodo($tabla) {
    global $pdo;
    if (!validarEstructuraDB($tabla)) return [];
    $stmt = $pdo->query("SELECT * FROM `$tabla` ORDER BY 1 DESC");
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

// Consulta genérica para estadísticas / agregados
function obtenerEstadisticas($tabla, $campoCont, $campoAgrupar) {
    global $pdo;
    if (!validarEstructuraDB($tabla)) return [];
    if (!validarEstructuraDB($tabla, $campoAgrupar)) return [];
    $stmt = $pdo->query("SELECT `$campoAgrupar`, COUNT(`$campoCont`) as total FROM `$tabla` GROUP BY `$campoAgrupar`");
    return $stmt->fetchAll();
}

// --- ESCRITURA (CREATE, UPDATE, DELETE) ---
function crearRegistro($tabla, $datos) {
    global $pdo;
    if (!validarEstructuraDB($tabla)) return false;
    $campos = array_keys($datos);
    $placeholders = array_fill(0, count($campos), '?');
    $sql = "INSERT INTO `$tabla` (" . implode(", ", array_map(fn($c) => "`$c`", $campos)) . ") VALUES (" . implode(", ", $placeholders) . ")";
    try {
        $stmt = $pdo->prepare($sql);
        $stmt->execute(array_values($datos));
        return $pdo->lastInsertId();
    } catch (PDOException $e) {
        return false;
    }
}

function actualizarRegistro($tabla, $id, $datos) {
    global $pdo;
    $campoId = obtenerPK($tabla);
    if (!$campoId || !validarEstructuraDB($tabla)) return false;
    $sets = []; $valores = [];
    foreach ($datos as $campo => $valor) {
        if (validarEstructuraDB($tabla, $campo)) {
            $sets[]   = "`$campo` = ?";
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
    } catch (PDOException $e) {
        return false;
    }
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
