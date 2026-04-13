<?php
// ============================================================
// network_manager.php — API REST para los 3 módulos del sistema
// Patrón idéntico a inventory_manager.php de inventarioSH
// ============================================================
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

require_once __DIR__ . '/crud.php';

$metodo   = $_SERVER['REQUEST_METHOD'];
$resource = $_GET['resource'] ?? null;
$id       = $_GET['id']       ?? null;
$campo    = $_GET['campo']    ?? null;
$valor    = $_GET['valor']    ?? null;
$agrupar  = $_GET['agrupar']  ?? null;
$contar   = $_GET['contar']   ?? null;

if ($metodo === 'OPTIONS') { http_response_code(200); exit; }
if (!$resource) enviarRespuesta(400, ["error" => "Recurso no especificado"]);

switch ($metodo) {
    case 'GET':
        // Modo estadísticas (agrupaciones para el dashboard)
        if ($agrupar && $contar) {
            enviarRespuesta(200, obtenerEstadisticas($resource, $contar, $agrupar));
        } elseif ($id) {
            $res = obtenerRegistroPorId($resource, $id);
            $res ? enviarRespuesta(200, $res) : enviarRespuesta(404, ["error" => "No encontrado"]);
        } elseif ($campo && $valor) {
            enviarRespuesta(200, obtenerListaPorCampo($resource, $campo, $valor));
        } else {
            enviarRespuesta(200, obtenerTodo($resource));
        }
        break;

    case 'POST':
        $datos   = json_decode(file_get_contents('php://input'), true);
        $nuevoId = crearRegistro($resource, $datos);
        $nuevoId ? enviarRespuesta(201, ["id" => $nuevoId])
                 : enviarRespuesta(500, ["error" => "Error al crear el registro"]);
        break;

    case 'PUT':
        if (!$id) enviarRespuesta(400, ["error" => "ID requerido para actualizar"]);
        $datos = json_decode(file_get_contents('php://input'), true);
        actualizarRegistro($resource, $id, $datos)
            ? enviarRespuesta(200, ["msg" => "Registro actualizado correctamente"])
            : enviarRespuesta(500, ["error" => "Error al actualizar"]);
        break;

    case 'DELETE':
        if (!$id) enviarRespuesta(400, ["error" => "ID requerido para eliminar"]);
        borrarPorID($resource, $id)
            ? enviarRespuesta(200, ["msg" => "Registro eliminado correctamente"])
            : enviarRespuesta(404, ["error" => "Registro no encontrado"]);
        break;

    default:
        enviarRespuesta(405, ["error" => "Método HTTP no permitido"]);
}

function enviarRespuesta($codigo, $datos) {
    http_response_code($codigo);
    echo json_encode($datos, JSON_UNESCAPED_UNICODE);
    exit;
}
?>
