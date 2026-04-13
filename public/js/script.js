// script.js
export const navigationItems = [
    { "icon": "fas fa-tachometer-alt", "label": "Dashboard", "active": false, "badge": "", "path": "/inventarioSH/public/vistas/index.html" },
    { "icon": "fas fa-boxes", "label": "Inventory", "active": false, "badge": "", "path": "/inventarioSH/public/vistas/inventario.html" },
    { "icon": "fas fa-chart-bar", "label": "Analisis", "active": false, "badge": "", "path": "#"}
];

export function renderNavigationMenu(items) {
    const menuContainer = document.getElementById("nav-menu");
    if (!menuContainer) return;

    const _path = window.location.pathname;
    
    const menuHTML = items.map(item => {
        // Lógica de active basada en la ruta actual
        const isActive = _path.endsWith(item.path);
        const activeClass = isActive 
            ? "bg-gray-800 text-white" 
            : "text-gray-300 hover:bg-gray-800 hover:text-white";
        
        return `
            <li>
                <a href="${item.path}" class="flex items-center px-4 py-3 rounded-lg ${activeClass} transition-colors">
                    <i class="${item.icon} mr-3"></i>
                    <span class="flex-1">${item.label}</span>
                </a>
            </li>
        `;
    }).join("");

    menuContainer.innerHTML = menuHTML;
}