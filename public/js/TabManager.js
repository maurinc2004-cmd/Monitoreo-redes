/**
 * @class TabManager
 * @description Clase utilitaria para gestionar la navegación por pestañas (tabs) en una interfaz.
 * Permite alternar la visibilidad de secciones de contenido y actualizar los estilos 
 * de los botones de navegación de forma automática.
 * * @example
 * // Uso básico (requiere clases .tab-btn y .tab-section en el HTML)
 * const tabs = new TabManager();
 * * @example
 * // Uso personalizado para una página de Configuración
 * const settingsTabs = new TabManager({
 * btnSelector: '.settings-nav',
 * sectionSelector: '.panel-content',
 * activeClasses: ['bg-blue-500', 'text-white']
 * });
 */
export class TabManager {
    /**
     * @param {Object} config - Configuración opcional para personalizar el comportamiento.
     * @param {string} [config.btnSelector='.tab-btn'] - Selector CSS para los botones que activan las pestañas.
     * @param {string} [config.sectionSelector='.tab-section'] - Selector CSS para las secciones de contenido que se mostrarán/ocultarán.
     * @param {Array<string>} [config.activeClasses] - Lista de clases de CSS (Tailwind) para el estado activo.
     * @param {Array<string>} [config.inactiveClasses] - Lista de clases de CSS (Tailwind) para el estado inactivo.
     */
    constructor(config = {}) {
        // Inicialización de selectores y elementos
        this.btnSelector = config.btnSelector || '.tab-btn';
        this.sectionSelector = config.sectionSelector || '.tab-section';
        
        // Estilos por defecto basados en el diseño de Inventario
        this.activeClasses = config.activeClasses || ['bg-primary', 'text-white', 'border-primary'];
        this.inactiveClasses = config.inactiveClasses || ['bg-white', 'text-gray-600', 'border-gray-200'];
        
        // Referencias al DOM
        this.buttons = document.querySelectorAll(this.btnSelector);
        this.sections = document.querySelectorAll(this.sectionSelector);
        this.pageTitle = document.getElementById('page-title');
        this.pageSubtitle = document.getElementById('page-subtitle');
        
        this.init();
    }

    /**
     * @private
     * @description Vincula los eventos de clic a los botones encontrados en el DOM.
     */
    init() {
        if (this.buttons.length === 0) return;

        this.buttons.forEach(btn => {
            btn.addEventListener('click', () => {
                const targetId = btn.getAttribute('data-target');
                this.switchTab(targetId, btn);
                this.updateHeader(btn.innerText);
            });
        });
    }

    /**
     * @description Realiza el intercambio visual de las pestañas.
     * @param {string} targetId - El ID de la sección que se desea mostrar.
     * @param {HTMLElement} activeBtn - El elemento del botón que recibió el clic.
     */
    switchTab(targetId, activeBtn) {
        // 1. Gestión de visibilidad de secciones (usa clases 'hidden' y 'flex')
        this.sections.forEach(section => {
            if (section.id === targetId) {
                section.classList.remove('hidden');
                section.classList.add('flex');
            } else {
                section.classList.add('hidden');
                section.classList.remove('flex');
            }
        });

        // 2. Gestión de estilos visuales de los botones
        this.buttons.forEach(btn => {
            if (btn === activeBtn) {
                btn.classList.add(...this.activeClasses);
                btn.classList.remove(...this.inactiveClasses);
            } else {
                btn.classList.remove(...this.activeClasses);
                btn.classList.add(...this.inactiveClasses);
            }
        });
    }

    /**
     * @description Actualiza los textos del encabezado de la página si existen.
     * @param {string} tabName - Nombre de la pestaña seleccionada.
     */
    updateHeader(tabName) {
        if (this.pageTitle) this.pageTitle.innerText = tabName;
        if (this.pageSubtitle) {
            this.pageSubtitle.innerText = `Gestión detallada de ${tabName.toLowerCase()}`;
        }
    }
}




/**
 * =============================================================================
 * MODULO: TabManager
 * =============================================================================
 * * INDICACIONES DE USO (GUÍA RÁPIDA):
 * * 1. REQUISITOS EN EL HTML:
 * - Botones: Deben tener una clase identificadora (por defecto '.tab-btn') 
 * y el atributo 'data-target' con el ID de la sección que activan.
 * - Secciones: Deben tener una clase identificadora (por defecto '.tab-section')
 * y un ID que coincida con el 'data-target' del botón.
 * * Ejemplo:
 * <button class="tab-btn" data-target="seccion-1">Inventario</button>
 * <div id="seccion-1" class="tab-section flex"> ... </div>
 * <div id="seccion-2" class="tab-section hidden"> ... </div>
 * * 2. REQUISITOS DE ESTILO (Tailwind):
 * - La clase usa 'hidden' para ocultar y 'flex' para mostrar.
 * * 3. INSTANCIACIÓN EN JS:
 * import { TabManager } from './TabManager.js';
 * const tabs = new TabManager();
 * * =============================================================================
 */