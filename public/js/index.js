import { renderNavigationMenu, navigationItems } from './script.js';


// --- Inicialización del Sistema ---
document.addEventListener('DOMContentLoaded', async () => {
    console.log("Iniciando Sistema de Control...");
    
    try {
        // 1. Componentes Globales
        renderNavigationMenu(navigationItems);
        

        

    } catch (error) {
        console.error("Error crítico en la inicialización:", error);
    }
});