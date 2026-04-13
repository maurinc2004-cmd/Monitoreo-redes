# Sistema de Monitoreo de Red LAN — Análisis Técnico e Implementación
**Autor:** Mauricio Niño | **Proyecto:** TEG MN-1001

---

## Arquitectura General

El sistema está compuesto por **3 programas independientes** que comparten la misma base de datos, API y capa de estilos, siguiendo exactamente el patrón arquitectónico del proyecto `inventarioSH`.

```
[Programa 1: Equipos]  [Programa 2: Seguridad]  [Programa 3: Archivos]
        |                       |                         |
        +----------+------------+-------------------------+
                   |
             API REST: network_manager.php
                   |
              crud.php (CRUD seguro con whitelist)
                   |
          MySQL: monitoreo_red_lan
```

---

## Estructura de Archivos Creados

```
monitoreo_red/
├── api/
│   ├── config.php              <- Conexión PDO a monitoreo_red_lan
│   ├── crud.php                <- CRUD genérico con whitelist de tablas/campos
│   └── network_manager.php     <- API REST (GET/POST/PUT/DELETE + Stats)
│
├── public/
│   ├── css/
│   │   └── stile.css           <- Estilos globales (badges, animaciones, etc.)
│   ├── js/
│   │   ├── tailwind.js         <- Config de tema Tailwind
│   │   ├── TabManager.js       <- Reutilizado de inventarioSH
│   │   ├── RenderTabla.js      <- Extendido con soporte de badge + animaciones
│   │   └── NetworkService.js   <- Cliente HTTP (igual a InventoryService + getStats)
│   └── vistas/
│       ├── equipos.html        <- PROGRAMA 1
│       ├── seguridad.html      <- PROGRAMA 2
│       └── monitoreo_archivos.html <- PROGRAMA 3
│
└── sql/
    └── monitoreo_red.sql       <- Esquema completo + datos de prueba
```

---

## Base de Datos — `monitoreo_red_lan` (10 tablas)

| Tabla | Módulo | Descripción |
|---|---|---|
| `equipos` | 1 | Dispositivos conectados a la LAN |
| `categorias_equipo` | 1 | Tipos de equipos |
| `transmisiones` | 1 | Log de tráfico entre equipos |
| `firewall_logs` | 2 | Eventos ALLOW/BLOCK del firewall |
| `amenazas` | 2 | Detecciones de malware/intrusiones |
| `reglas_proxy` | 2 | Reglas de filtrado DNS/Proxy |
| `sesiones_admin` | 2 | Sesiones de administrador |
| `archivos_monitoreados` | 3 | Archivos detectados en tránsito |
| `transferencias_ftp` | 3 | Historial de operaciones FTP |
| `usuarios` | Compartida | Administradores y soporte técnico |

---

## Los Tres Programas

### Programa 1 — equipos.html
**Conectar Equipos, Información, Organización y Transmisión**

| Pestaña | Función |
|---|---|
| Equipos Conectados | CRUD de dispositivos + estadísticas por estado |
| Información de Red | Config (IP, Gateway, DNS, DHCP) + gráfico por tipo |
| Organización | Vista por departamento + formulario alta de equipos |
| Transmisiones | Log de tráfico TCP/UDP/ICMP + registro manual |

### Programa 2 — seguridad.html
**Seguridad de Red**

| Pestaña | Función |
|---|---|
| Firewall / Logs | Eventos IN/OUT con acciones ALLOW/BLOCK/DROP |
| Amenazas | Malware, intrusiones, PortScan, BruteForce con severidad |
| Proxy & DNS | Reglas de filtrado de dominios (Squid + Pi-hole) |
| Sesión Administrador | Control de acceso, usuarios e historial de sesiones |

### Programa 3 — monitoreo_archivos.html
**Monitoreo de Archivos y Gestor FTP**

| Pestaña | Función |
|---|---|
| Monitoreo | Archivos detectados con búsqueda/filtro por estado |
| Gestor FTP | CRUD de transferencias UPLOAD/DOWNLOAD |
| Cuarentena | Archivos sospechosos + verificador de hash MD5 |
| Historial | Vista completa + gráfico por extensión |

---

## Instalación (XAMPP)

1. Copia la carpeta `monitoreo_red/` a `C:\xampp\htdocs\`
2. Ejecuta el SQL en phpMyAdmin: `monitoreo_red/sql/monitoreo_red.sql`
3. Inicia Apache y MySQL en XAMPP
4. Accede a los tres programas:

| Programa | URL |
|---|---|
| Equipos | http://localhost/monitoreo_red/public/vistas/equipos.html |
| Seguridad | http://localhost/monitoreo_red/public/vistas/seguridad.html |
| Archivos FTP | http://localhost/monitoreo_red/public/vistas/monitoreo_archivos.html |

---

## Correspondencia con el Mapa Conceptual

| Nodo del Mapa | Implementado en |
|---|---|
| Conectar Equipos a la red LAN | equipos.html - Tab "Equipos" |
| Información de máquinas y dispositivos | equipos.html - Tab "Información" |
| Organización por categorías + transmisión | equipos.html - Tabs "Organización" y "Transmisiones" |
| Firewall entrada/salida + detección malware | seguridad.html - Tabs "Firewall" y "Amenazas" |
| Proxy filtrar IPs + DNS traducción dominios | seguridad.html - Tab "Proxy & DNS" |
| Sesión administrador para jefe y soporte | seguridad.html - Tab "Sesión Administrador" |
| Monitoreo de archivos en equipos | monitoreo_archivos.html - Tabs "Monitoreo" y "Cuarentena" |
| Gestor FTP cliente y servidor LAN | monitoreo_archivos.html - Tab "Gestor FTP" |
