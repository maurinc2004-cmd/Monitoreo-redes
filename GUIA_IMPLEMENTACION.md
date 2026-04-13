# Guía de Implementación y Ejecución - Sistema de Monitoreo de Red LAN

Esta guía detalla los pasos necesarios para instalar, configurar y ejecutar el los tres módulos del "Sistema de Monitoreo de Red LAN". El sistema está desarrollado con **PHP (backend/API)**, **MySQL/MariaDB (base de datos)** y **HTML/CSS/JS (frontend con Tailwind CSS y FontAwesome)**.

---

## 1. Requisitos Previos y Dependencias

Para ejecutar este proyecto, necesitas un entorno de servidor web local. Se recomienda usar **XAMPP**, **WAMP**, o **Laragon** en Windows.

### Dependencias de Software:
*   **Servidor Web:** Apache (incluido en XAMPP).
*   **PHP:** Versión 7.4 o superior (recomendado PHP 8.x).
    *   *Extensión obligatoria:* `pdo_mysql` (Suele venir activada por defecto en XAMPP).
*   **Base de Datos:** MySQL 5.7+ o MariaDB 10.4+ (incluido en XAMPP).
*   **Navegador Web:** Google Chrome, Mozilla Firefox, o Microsoft Edge (actualizados).
*   **Conexión a Internet:** Requerida **únicamente** para cargar los estilos de Tailwind CSS y los íconos de FontAwesome a través de sus respectivos CDNs en el Frontend.

---

## 2. Preparación del Entorno (Usando XAMPP)

1.  **Descargar e Instalar XAMPP:** Si no lo tienes, descárgalo desde [apachefriends.org](https://www.apachefriends.org/) e instálalo.
2.  **Iniciar Servicios:** Abre el Panel de Control de XAMPP (XAMPP Control Panel).
3.  **Encender Módulos:** Haz clic en los botones **"Start"** de los módulos **Apache** y **MySQL**. Ambos deben quedar resaltados en color verde.

---

## 3. Despliegue del Código

Debes ubicar la carpeta del proyecto dentro del directorio público de tu servidor local.

1.  Copia la carpeta completa llamada `monitoreo_red` (la que contiene `api`, `public` y `sql`).
2.  Pégala dentro de la carpeta `htdocs` de XAMPP.
    *   *Ruta típica en Windows:* `C:\xampp\htdocs\monitoreo_red\`

La estructura debe quedar así:
```text
C:\xampp\htdocs\monitoreo_red\
 ├── api\
 │    ├── config.php
 │    ├── crud.php
 │    └── network_manager.php
 ├── public\
 │    └── ... (css, js, vistas)
 └── sql\
      └── monitoreo_red.sql
```

---

## 4. Instalación de la Base de Datos

El sistema viene con un script SQL que crea la base de datos `monitoreo_red_lan`, sus tablas y añade datos de prueba iniciales.

1.  Abre tu navegador web y entra a **phpMyAdmin**: [http://localhost/phpmyadmin/](http://localhost/phpmyadmin/)
2.  En la barra superior, haz clic en la pestaña **"Importar"**.
3.  Haz clic en el botón **"Seleccionar archivo"** (o "Elegir archivo").
4.  Busca y selecciona el archivo SQL en la carpeta de tu proyecto:
    `C:\xampp\htdocs\monitoreo_red\sql\monitoreo_red.sql`
5.  Desplázate hasta abajo y haz clic en el botón **"Importar"** (o "Continuar").
6.  *Verificación:* Deberías ver un mensaje en verde confirmando que la importación fue exitosa. A la izquierda, verás creada la base de datos `monitoreo_red_lan`.

---

## 5. Configuración de la Conexión (Opcional)

Si tu servidor MySQL tiene una configuración por defecto (usuario `root` y sin contraseña), **no necesitas hacer nada en este paso**.

Si configuraste una contraseña para tu base de datos MySQL, debes actualizar el archivo de configuración:

1.  Abre el archivo `C:\xampp\htdocs\monitoreo_red\api\config.php` en tu editor de código.
2.  Busca la línea: `'password' => '',`
3.  Coloca tu contraseña entre las comillas simples, por ejemplo: `'password' => 'mi_contraseña_secreta',`
4.  Guarda el archivo.

---

## 6. Ejecución y Uso de los Programas

¡El sistema ya está listo para usarse! Abre tu navegador web y accede a través de las siguientes URLs para operar cada uno de los módulos:

### Programa 1: Conectar Equipos y Transmisiones
*   **Propósito:** Gestionar el inventario de equipos en la red, ver su organización, configurar IPs y registrar/ver el histórico de transmisiones (Bytes enviados/recibidos).
*   **URL:** [http://localhost/monitoreo_red/public/vistas/equipos.html](http://localhost/monitoreo_red/public/vistas/equipos.html)

### Programa 2: Seguridad de Red
*   **Propósito:** Monitorear logs del firewall, reglas de dominio/proxy, alertas de amenazas (intrusiones, malware) y administrar las sesiones de control.
*   **URL:** [http://localhost/monitoreo_red/public/vistas/seguridad.html](http://localhost/monitoreo_red/public/vistas/seguridad.html)

### Programa 3: Monitoreo de Archivos y FTP
*   **Propósito:** Rastrear archivos transferidos en la red, gestionar la cuarentena de archivos sospechosos, verificar Hashes MD5 y ver el log de transferencias del gestor FTP.
*   **URL:** [http://localhost/monitoreo_red/public/vistas/monitoreo_archivos.html](http://localhost/monitoreo_red/public/vistas/monitoreo_archivos.html)

---

## 🛠️ Notas de Resolución de Problemas (Troubleshooting)

*   **Los datos no cargan o sale error de conexión:** Asegúrate de que MySQL esté encendido en XAMPP y que hayas importado correctamente el archivo `.sql`. Revisa que la URL en el navegador empiece por `http://localhost/` y no por `file:///C:/...`
*   **El diseño se ve mal o sin estilos:** Verifica que tienes conexión a internet activa, ya que el sistema descarga Tailwind CSS y FontAwesome remotamente.
*   **Los archivos no se actualizan (Caché):** Si modificas un archivo JS o HTML y no ves los cambios, presiona `Ctrl + F5` en tu navegador para forzar la recarga ignorando la caché.
