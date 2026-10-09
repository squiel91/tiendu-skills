# Store settings

Settings live under **Ajustes** (`/admin/tiendas/{storeHandle}/ajustes`) in three groups, plus a few pages in the main menu.

| Group | Tabs | Covers |
|---|---|---|
| **Negocio** | General, Cobros, Logística, Marketing | Store data, notifications, team, payments, delivery, marketing integrations. |
| **Tienda** | Tema, Personalización, Dominios, Desarrollo y API | Theme and previews, checkout/email look, domains, developer tools. |
| **Manu** | (one page) | AI credits, WhatsApp, assistant rules, Meta Ads and Google Analytics connections. |

Outside Ajustes: **Suscripción** (`/suscripcion`) and **Soporte** (`/soporte`).

## General (Negocio)

- **Nombre de tu tienda**, **Número de WhatsApp** and **Email principal**: contact data shoppers can use.
- **Notificaciones por email**: choose which events email the seller (new order, new review, verified subscriber, upcoming special date).
- **Confirmación automática de pedidos**: paid orders are confirmed automatically (see the orders guide).
- **Redirecciones y Reescrituras**: URL rules (see the URL rules guide).
- **Equipo y permisos**: collaborators (see the team guide).
- **Visibilidad**: a store that is not listed (`isListed: false`) cannot be reached by visitors or customers. Listing it again makes it public.
- **Borrar tienda** is permanent and only for owners.

`store_get` and `store_update` read and change these settings. Changing the `hostname` or a public URL path (`productPath`, `categoryPath`, `pagePath`, `blogPostPath`) changes public URLs; add URL rules for the old paths when needed.

## Payments and delivery

**Cobros** and **Logística** are described in the orders and shipping guide. **Marketing** holds the marketing integrations (Meta catalog, Google Merchant, Google Analytics tag, Mailgun, Mercado Libre) and the sender data for campaign emails.

## Domains

**Tienda → Dominios** lists the hostnames of the store. A domain can be enabled or disabled, made the primary domain, or removed. A domain with a redirect target answers every request with a 301 to that URL, keeping path and query.

## Theme

**Tienda → Tema** lists the theme previews. Git branches create previews; publishing is a push to `live`, and deleting a preview deletes its branch. **Personalizar** opens the visual customizer on a preview. See the theme skill for code.
