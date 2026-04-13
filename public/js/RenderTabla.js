/**
 * Clase para gestionar el renderizado y eventos de tablas de datos dinámicas.
 * @class
 */
export class RenderTabla {
    /**
     * Crea una instancia de DataTable.
     * @param {string} containerId - El ID del elemento HTML <tbody> donde se renderizarán los datos.
     * @param {Object} options - Configuración de la tabla.
     * @param {string} [options.idField='id'] - Nombre de la propiedad que actúa como identificador único (PK).
     * @param {Array<Object>} options.columns - Definición de columnas a mostrar.
     * @param {string} options.columns[].field - Nombre de la propiedad en el objeto de datos.
     * @param {string} [options.columns[].className] - Clases CSS opcionales para la celda.
     * @param {Function} [options.onEdit] - Callback ejecutado al pulsar editar. Recibe el ID del registro.
     * @param {Function} [options.onDelete] - Callback ejecutado al pulsar eliminar. Recibe el ID del registro.
     */
    constructor(containerId, options = {}) {
        /** @type {HTMLElement|null} */
        this.tbody = document.getElementById(containerId);
        this.columns = options.columns || [];
        this.onEdit = options.onEdit || (() => {});
        this.onDelete = options.onDelete || (() => {});
        this.idField = options.idField || 'id';

        this.init();
    }

    /**
     * Inicializa los escuchadores de eventos mediante delegación.
     * Se usa delegación en el contenedor padre para mejorar el rendimiento.
     * @private
     */
    init() {
        if (!this.tbody) {
            console.error(`DataTable: No se encontró el contenedor #${this.tbody}`);
            return;
        }
        
        this.tbody.addEventListener('click', (e) => {
            // Busca el botón más cercano al clic (maneja clics en el icono interno)
            const btnEdit = e.target.closest('.btn-edit');
            const btnDelete = e.target.closest('.btn-delete');

            if (btnEdit) {
                this.onEdit(btnEdit.dataset.id);
            } else if (btnDelete) {
                this.onDelete(btnDelete.dataset.id);
            }
        });
    }

    /**
     * Renderiza las filas de la tabla basadas en un array de objetos.
     * @param {Array<Object>} data - Lista de objetos a mostrar en la tabla.
     */
    render(data) {
        if (!this.tbody) return;
        
        // Limpiar contenido previo para evitar duplicados
        this.tbody.innerHTML = "";

        // Estado vacío: Si no hay datos, mostrar mensaje de feedback
        if (!data || data.length === 0) {
            this.renderEmptyState();
            return;
        }

        // Construcción de filas
        data.forEach(item => {
            const row = document.createElement('tr');
            row.className = "hover:bg-gray-50 transition-colors border-b border-gray-100";

            row.innerHTML = `
                <td class="px-6 py-4">
                    <span class="px-2 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                        # ${item[this.idField]}
                    </span>
                </td>
                ${this.renderCells(item)}
                ${this.renderActions(item[this.idField])}
            `;
            this.tbody.appendChild(row);
        });
    }

    /**
     * Genera el HTML para las celdas de datos de una fila.
     * @param {Object} item - El objeto de datos de la fila actual.
     * @returns {string} HTML de las celdas <td>.
     * @private
     */
    renderCells(item) {
        return this.columns.map(col => `
            <td class="px-6 py-4 ${col.className || 'text-gray-600'}">
                ${item[col.field] ?? ''}
            </td>
        `).join('');
    }

    /**
     * Genera el HTML de la columna de acciones (Editar/Eliminar).
     * @param {string|number} id - El ID del registro para los atributos data-id.
     * @returns {string} HTML de la celda de acciones.
     * @private
     */
    renderActions(id) {
        return `
            <td class="px-6 py-4 text-right space-x-3">
                <button class="btn-edit text-blue-600 hover:text-blue-900" data-id="${id}" title="Editar">
                    <i class="fas fa-edit pointer-events-none"></i>
                </button>
                <button class="btn-delete text-red-600 hover:text-red-900" data-id="${id}" title="Eliminar">
                    <i class="fas fa-trash pointer-events-none"></i>
                </button>
            </td>
        `;
    }

    /**
     * Muestra un mensaje visual cuando no hay datos disponibles.
     * @private
     */
    renderEmptyState() {
        this.tbody.innerHTML = `
            <tr>
                <td colspan="${this.columns.length + 2}" class="px-6 py-4 text-center text-gray-500 italic">
                    No se encontraron registros disponibles.
                </td>
            </tr>`;
    }
}