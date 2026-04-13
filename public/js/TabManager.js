/**
 * TabManager.js — Reutilizado del proyecto inventarioSH
 * Gestión de pestañas/navegación para los tres módulos
 */
export class TabManager {
    constructor(config = {}) {
        this.btnSelector     = config.btnSelector     || '.tab-btn';
        this.sectionSelector = config.sectionSelector || '.tab-section';
        this.activeClasses   = config.activeClasses   || ['bg-primary', 'text-white', 'border-primary'];
        this.inactiveClasses = config.inactiveClasses || ['bg-white', 'text-gray-600', 'border-gray-200'];

        this.buttons  = document.querySelectorAll(this.btnSelector);
        this.sections = document.querySelectorAll(this.sectionSelector);
        this.pageTitle    = document.getElementById('page-title');
        this.pageSubtitle = document.getElementById('page-subtitle');

        this.init();
    }

    init() {
        if (this.buttons.length === 0) return;
        this.buttons.forEach(btn => {
            btn.addEventListener('click', () => {
                const targetId = btn.getAttribute('data-target');
                this.switchTab(targetId, btn);
                this.updateHeader(btn.innerText.trim());
            });
        });
    }

    switchTab(targetId, activeBtn) {
        this.sections.forEach(section => {
            if (section.id === targetId) {
                section.classList.remove('hidden');
                section.classList.add('flex');
            } else {
                section.classList.add('hidden');
                section.classList.remove('flex');
            }
        });
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

    updateHeader(tabName) {
        if (this.pageTitle)    this.pageTitle.innerText    = tabName;
        if (this.pageSubtitle) this.pageSubtitle.innerText = `Gestión de ${tabName.toLowerCase()}`;
    }
}
