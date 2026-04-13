/**
 * inventario.js
 * Gestión de la interfaz de inventario, carga de datos y eventos.
 * * MEJORAS REALIZADAS:
 * 1. Eliminación de la función btnDelete que se autoejecutaba incorrectamente.
 * 2. Unificación de la lógica de eventos mediante Delegación de Eventos.
 * 3. Validaciones de existencia de elementos del DOM para evitar errores de JS.
 */

import { InventoryService } from './inventoryService.js';
import { renderNavigationMenu, navigationItems } from './script.js';
import { TabManager } from "./TabManager.js";
import { RenderTabla } from "./RenderTabla.js";

// Configuración de la API
const CONFIG = {
    inventoryAPI_url: "http://localhost/inventarioSH/api/inventory_manager.php"
};

document.addEventListener('DOMContentLoaded', async () => {
    console.log("Iniciando Sistema de Control...");
    
    try {
        // --- 1. Inicialización de Componentes ---
        renderNavigationMenu(navigationItems);
        new TabManager(); // No se requiere asignar a variable si no se usará después

        // Inicializar el servicio de datos
        const inventoryAPI = new InventoryService(CONFIG.inventoryAPI_url);

        // --- 2. Configuración de la Tabla de Modelos ---
        // Definimos la estructura pero no asignamos eventos aquí para evitar conflictos
        const tablaModelos = new RenderTabla("tbody-modelos", {
            idField: "ID_Modelo",
            columns: [
                { field: "Marca" },
                { field: "Modelo" },
                { field: "Categoria" },
            ]
        });

        // Carga inicial de datos desde el servidor
        const datos_modelos = await inventoryAPI.getAll("modelos");
        tablaModelos.render(datos_modelos);

        // --- 3. Delegación de Eventos para la Tabla ---
        // Manejamos Editar y Eliminar en un solo bloque para mayor eficiencia
        const tbodyModelos = document.getElementById('tbody-modelos');
        
        if (tbodyModelos) {
            tbodyModelos.addEventListener('click', async (e) => {
                // Buscamos el botón más cercano al clic (por si hacen clic en el icono dentro del botón)
                const targetBtn = e.target.closest('button');
                if (!targetBtn) return;

                const id = targetBtn.dataset.id;

                // Lógica para el botón ELIMINAR
                if (targetBtn.classList.contains('btn-delete')) {
                    const confirmar = confirm(`¿Estás seguro de que deseas eliminar el modelo #${id}?`);
                    
                    if (confirmar) {
                        try {
                            await inventoryAPI.delete("modelos", id);
                            
                            // Refrescar datos localmente tras éxito
                            const nuevosDatos = await inventoryAPI.getAll("modelos");
                            tablaModelos.render(nuevosDatos);
                            
                            alert("Modelo eliminado correctamente.");
                        } catch (err) {
                            alert("Error al eliminar: " + err.message);
                        }
                    }
                }
        
                // Lógica para el botón EDITAR
                if (targetBtn.classList.contains('btn-edit')) {
                    console.log("Iniciando edición del ID:", id);
                    alert(`Funcionalidad de edición para el ID ${id} en desarrollo.`);
                }
            });
        }

        // --- 4. Gestión del Formulario de Alta ---
        const formModelos = document.getElementById("form-modelos");
        const Fecha_produccion = formModelos.querySelector('[name="Fecha_produccion"]');
        const Fin_soporte = formModelos.querySelector('[name="Fin_soporte"]');
        // 1. Obtenemos la fecha actual en formato YYYY-MM-DD
        const hoy = new Date().toISOString().split('T')[0];

        // 2. Asignamos el valor por defecto
        Fecha_produccion.value = hoy;
        Fin_soporte.value = hoy;

        if (formModelos) {
            formModelos.addEventListener("submit", async (e) => {
                e.preventDefault();
                
                // Conversión automática de campos del formulario a objeto JSON
                const data = Object.fromEntries(new FormData(formModelos));
                
                try {
                    // Enviar datos a la API
                    await inventoryAPI.create("modelos", data);
                    
                    alert("¡Modelo guardado con éxito!");
                    formModelos.reset(); // Limpiar campos
                    
                    // Recargar la tabla para mostrar el nuevo registro
                    const nuevosDatos = await inventoryAPI.getAll("modelos");
                    tablaModelos.render(nuevosDatos);
                    
                } catch (error) {
                    alert("Error al guardar: " + error.message);
                }
            });
        }

    } catch (error) {
        console.error("Error crítico en la inicialización:", error);
    }
});