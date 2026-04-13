/**
 * NetworkService.js — Servicio HTTP para la API del monitoreo LAN
 * Basado en InventoryService.js del proyecto inventarioSH
 */
export class NetworkService {
    constructor(baseURL) {
        this.baseURL = baseURL;
    }

    async request(resource, options = {}) {
        const { method = 'GET', id = null, queryParams = {}, body = null } = options;

        let url = new URL(this.baseURL);
        url.searchParams.append('resource', resource);
        if (id) url.searchParams.append('id', id);
        Object.entries(queryParams).forEach(([k, v]) => url.searchParams.append(k, v));

        const config = { method, headers: { 'Content-Type': 'application/json' } };
        if (body) config.body = JSON.stringify(body);

        try {
            const response = await fetch(url, config);
            if (!response.ok) {
                const err = await response.json();
                throw new Error(err.error || `HTTP ${response.status}`);
            }
            return await response.json();
        } catch (error) {
            console.error(`[NetworkService] ${method} ${resource}:`, error.message);
            throw error;
        }
    }

    getAll(resource)               { return this.request(resource); }
    getById(resource, id)          { return this.request(resource, { id }); }
    getByField(resource, campo, valor) {
        return this.request(resource, { queryParams: { campo, valor } });
    }
    getStats(resource, contar, agrupar) {
        return this.request(resource, { queryParams: { contar, agrupar } });
    }
    create(resource, data)         { return this.request(resource, { method: 'POST', body: data }); }
    update(resource, id, data)     { return this.request(resource, { method: 'PUT', id, body: data }); }
    delete(resource, id)           { return this.request(resource, { method: 'DELETE', id }); }
}
