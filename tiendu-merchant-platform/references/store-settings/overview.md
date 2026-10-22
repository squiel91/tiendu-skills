# Store settings

Settings live under **Ajustes** (`/admin/tiendas/{storeHandle}/ajustes`) in three groups, plus a few pages in the main menu.

| Group | Tabs | Covers |
|---|---|---|
| **Negocio** | General, Cobros, Logística, Marketing | Store data, notifications, team, payments, delivery, marketing integrations, dangerous actions. |
| **Tienda** | General, Tema, Personalización, Dominios, Desarrollo y API | Order confirmation, URL rules, listing visibility, theme and previews, checkout/email look, domains, developer tools. |
| **Manu** | (one page) | AI credits, WhatsApp, assistant rules, Meta Ads and Google Analytics connections. |

Outside Ajustes: **Suscripción** (`/suscripcion`) and **Soporte** (`/soporte`).

## General (Negocio)

- **Nombre de tu tienda**, **Número de WhatsApp** and **Email principal**: contact data shoppers can use.
- **Notificaciones por email**: choose which events email the seller (new order, new review, verified subscriber, upcoming special date).
- **Equipo y permisos**: collaborators (see the team guide).
- **Riesgoso → Borrar negocio** is permanent and only for owners.

## General (Tienda)

- **Confirmación automática de pedidos**: paid orders are confirmed automatically (see the orders guide).
- **Redirecciones y Reescrituras**: URL rules (see the URL rules guide).
- **Visibilidad**: **Deslistar tienda** hides a store that is listed, so visitors and customers cannot reach it (`isListed: false`). **Listar tienda** makes it public again.

`store_get` and `store_update` read and change store settings. Public resource paths come from the published theme's `config/routes.json`; change them through the theme Git workflow and add URL rules for old paths when needed. The Merchant REST API retrieves and updates the current store; store creation and deletion remain Merchant Center operations.

## Payments and delivery

**Cobros** and **Logística** are described in the orders and shipping guide. **Marketing** holds the marketing integrations (Meta catalog, Google Merchant, Google Analytics tag, Mailgun, Mercado Libre) and the sender data for campaign emails.

## Domains

**Tienda → Dominios** is where the merchant buys a `.uy` domain, connects one they already own, and manages email, DNS, the primary hostname and redirects. The full rules and the screen-by-screen guide are in [Domains](../domains/overview.md).

## Theme

**Tienda → Tema** lists the theme previews. Git branches create previews; publishing is a push to `live`, and deleting a preview deletes its branch. See the theme skill for code.

## API reference

[Stores REST API](../api/stores/overview.md).
