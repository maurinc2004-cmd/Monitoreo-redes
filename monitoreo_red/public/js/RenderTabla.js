/**
 * RenderTabla.js — Reutilizado del proyecto inventarioSH
 * Renderizador de tablas de datos dinámicas para los tres módulos
 */
export class RenderTabla {
    constructor(containerId, options = {}) {
        this.tbody    = document.getElementById(containerId);
        this.columns  = options.columns  || [];
        this.onEdit   = options.onEdit   || (() => {});
        this.onDelete = options.onDelete || (() => {});
        this.idField  = options.idField  || 'id';
        this.acciones = options.acciones !== false; // true por defecto
        this.init();
    }

    init() {
        if (!this.tbody) return;
        this.tbody.addEventListener('click', (e) => {
            const btnEdit   = e.target.closest('.btn-edit');
            const btnDelete = e.target.closest('.btn-delete');
            const btnView   = e.target.closest('.btn-view');

            if (btnEdit)   this.onEdit(btnEdit.dataset.id);
            if (btnDelete) this.onDelete(btnDelete.dataset.id);
            if (btnView && options.onView) options.onView(btnView.dataset.id);
        });
    }

    render(data) {
        if (!this.tbody) return;
        this.tbody.innerHTML = "";
        if (!data || data.length === 0) { this.renderEmptyState(); return; }

        data.forEach((item, index) => {
            const row = document.createElement('tr');
            row.className = "hover:bg-gray-50 transition-colors border-b border-gray-100 fade-in-up";
            row.style.animationDelay = `${index * 40}ms`;
            row.innerHTML = `
                <td class="px-6 py-4">
                    <span class="px-2 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                        # ${item[this.idField]}
                    </span>
                </td>
                ${this.renderCells(item)}
                ${this.acciones ? this.renderActions(item[this.idField]) : ''}
            `;
            this.tbody.appendChild(row);
        });
    }

    renderCells(item) {
        return this.columns.map(col => {
            let valor = item[col.field] ?? '—';
            // Renders de badge si el campo tiene un mapa de colores
            if (col.badge) {
                const cls = col.badge[valor] || 'bg-gray-100 text-gray-700';
                valor = `<span class="px-2 py-0.5 rounded-full text-xs font-semibold ${cls}">${valor}</span>`;
            }
            return `<td class="px-6 py-4 ${col.className || 'text-gray-600'}">${valor}</td>`;
        }).join('');
    }

    renderActions(id) {
        return `
            <td class="px-6 py-4 text-right space-x-3">
                <button class="btn-edit text-blue-600 hover:text-blue-900 transition-colors" data-id="${id}" title="Editar">
                    <i class="fas fa-edit pointer-events-none"></i>
                </button>
                <button class="btn-delete text-red-500 hover:text-red-800 transition-colors" data-id="${id}" title="Eliminar">
                    <i class="fas fa-trash pointer-events-none"></i>
                </button>
            </td>
        `;
    }

    renderEmptyState() {
        this.tbody.innerHTML = `
            <tr>
                <td colspan="${this.columns.length + 2}" class="px-6 py-10 text-center text-gray-400">
                    <i class="fas fa-database text-3xl mb-3 block opacity-30"></i>
                    No se encontraron registros disponibles.
                </td>
            </tr>`;
    }
}
