# Development and API

**Ajustes → Tienda → Desarrollo y API** gathers the tools for integrations. Public references live at [docs.tiendu.uy](https://docs.tiendu.uy).

| Section | What it does |
|---|---|
| **Agente IA** | Links to the guide for connecting an external AI agent (MCP, skills, CLI). |
| **Editor de código** | Opens the store's development environment in the browser: theme files, VS Code and a terminal, the same files Manu uses. |
| **Claves de API** | Creates API keys for the REST API. |
| **Webhooks** | Notifies another application of product, collection and order changes. **Habilitar webhooks**, a **URL del webhook (HTTPS)**, **Eventos suscritos** and a signing secret shown only when created or rotated. **Enviar prueba** and **Entregas recientes** (event, status, attempts, HTTP code) help debugging. |
| **Funciones** | Server-side JavaScript endpoints (see the Functions guide). |
| **Modo desarrollador** | Enables store metadata (custom fields). See the metadata guide. |

Webhook delivery is at-least-once with up to three attempts; receivers must deduplicate by the payload `id` or the `Tiendu-Event-Id` header.
