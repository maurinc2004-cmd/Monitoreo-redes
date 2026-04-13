<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");

require_once __DIR__ . '/crud.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$resource = $_GET['resource'] ?? null;
$id = $_GET['id'] ?? null;
$campo = $_GET['campo'] ?? null;
$valor = $_GET['valor'] ?? null;

if ($metodo == 'OPTIONS') {
    http_response_code(200);
    exit;
}
if (!$resource) enviarRespuesta(400, ["error" => "Recurso no especificado"]);

switch ($metodo) {
    case 'GET':
        if ($id) {
            $res = obtenerRegistroPorId($resource, $id);
            $res ? enviarRespuesta(200, $res) : enviarRespuesta(404, ["error" => "No encontrado"]);
        } elseif ($campo && $valor) {
            enviarRespuesta(200, obtenerListaPorCampo($resource, $campo, $valor));
        } else {
            enviarRespuesta(200, obtenerTodo($resource));
        }
        break;

    case 'POST':
        $datos = json_decode(file_get_contents('php://input'), true);
        $nuevoId = crearRegistro($resource, $datos);
        $nuevoId ? enviarRespuesta(201, ["id" => $nuevoId]) : enviarRespuesta(500, ["error" => "Error al crear"]);
        break;

    case 'PUT':
        if (!$id) enviarRespuesta(400, ["error" => "ID requerido"]);
        $datos = json_decode(file_get_contents('php://input'), true);
        actualizarRegistro($resource, $id, $datos) ? enviarRespuesta(200, ["msg" => "Actualizado"]) : enviarRespuesta(500, ["error" => "Error al actualizar"]);
        break;

    case 'DELETE':
        if (!$id) enviarRespuesta(400, ["error" => "ID requerido"]);
        borrarPorID($resource, $id) ? enviarRespuesta(200, ["msg" => "Eliminado"]) : enviarRespuesta(404, ["error" => "No existe"]);
        break;

    default:
        enviarRespuesta(405, ["error" => "Método no permitido"]);
}

function enviarRespuesta($codigo, $datos)
{
    http_response_code($codigo);
    echo json_encode($datos);
    exit;
}
