# Development and API

**Ajustes → Tienda → Desarrollo y API** gathers the tools for integrations. Public references live at [docs.tiendu.uy](https://docs.tiendu.uy).

| Section | What it does |
|---|---|
| **Agente IA** | Links to the guide for connecting an external AI agent (MCP, skills, CLI). |
| **Claves de API** | Creates API keys for the REST API. |
| **Modo desarrollador** | Includes render errors and warnings as HTML comments at the start of the published storefront, and allows browser calls to the Store API and overlay embedding from `http://localhost` and `http://127.0.0.1` on any port. Previews always include rendering diagnostics, even when this setting is off. |
| **Funciones** | Server-side JavaScript endpoints (see the Functions guide). |
| **Webhooks** | Notifies another application of product, collection and order changes. **Habilitar webhooks**, a **URL del webhook (HTTPS)**, **Eventos suscritos** and a signing secret shown only when created or rotated. **Enviar prueba** and **Entregas recientes** (event, status, attempts, HTTP code) help debugging. |
| **Entorno de Manu** | Opens the store's full environment in the browser: the same files, VS Code and terminal that Manu uses. |
| **Base de datos** | Store SQLite tables, schema, row explorer and JavaScript console. See [Store database](../store-database/overview.md). |
| **Metadatos** | Deprecated custom JSON fields. The section shows a **Deprecado** label. New data goes in the [store database](../store-database/overview.md). |

Webhook delivery is at-least-once with up to three attempts; receivers must deduplicate by the payload `id` or the `Tiendu-Event-Id` header.
