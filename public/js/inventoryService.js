export class InventoryService {
    constructor(baseURL) {
        this.baseURL = baseURL;
    }

    /**
     * Método genérico para peticiones HTTP
     */
    async request(resource, options = {}) {
        const { method = 'GET', id = null, queryParams = {}, body = null } = options;
        
        // Construcción de la URL con parámetros
        let url = new URL(this.baseURL);
        url.searchParams.append('resource', resource);
        
        if (id) url.searchParams.append('id', id);
        
        // Añadir parámetros de búsqueda (campo y valor) si existen
        Object.keys(queryParams).forEach(key => 
            url.searchParams.append(key, queryParams[key])
        );

        const config = {
            method,
            headers: {
                'Content-Type': 'application/json'
            }
        };

        if (body) {
            config.body = JSON.stringify(body);
        }

        try {
            const response = await fetch(url, config);
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || 'Error en la petición');
            }
            return await response.json();
        } catch (error) {
            console.error(`Error en ${method} ${resource}:`, error.message);
            throw error;
        }
    }

    // --- Métodos de Interacción ---

    // Obtener todos los registros de una tabla
    async getAll(resource) {
        return this.request(resource);
    }

    // Obtener un registro por su ID
    async getById(resource, id) {
        return this.request(resource, { id });
    }

    // Buscar por campo específico (ej: buscar por Marca)
    async getByField(resource, campo, valor) {
        return this.request(resource, { 
            queryParams: { campo, valor } 
        });
    }

    // Crear un nuevo registro
    async create(resource, data) {
        return this.request(resource, {
            method: 'POST',
            body: data
        });
    }

    // Actualizar un registro existente
    async update(resource, id, data) {
        return this.request(resource, {
            method: 'PUT',
            id: id,
            body: data
        });
    }

    // Eliminar un registro
    async delete(resource, id) {
        return this.request(resource, {
            method: 'DELETE',
            id: id
        });
    }
}