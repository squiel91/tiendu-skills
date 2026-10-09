# Manu settings, plan and support

## Manu page

**Ajustes → Manu** (`/ajustes/manu`):

| Section | What it holds |
|---|---|
| **Créditos de IA** | Remaining monthly balance. One credit is one US cent. |
| **Aplicaciones de Manu** | **WhatsApp** (see below), **Meta Ads** and **Google Analytics** connections. |
| **Reglas del asistente** | Up to 6 rules per store, 2024 characters each. They apply to the panel chat and WhatsApp. |
| **Permisos permanentes de Manu** | Actions the seller allowed Manu to repeat without asking. |
| **Instrucciones para imágenes** | Default instructions for generated images. |

Manu chat is the **¿Te doy una mano?** button on the right of the panel; it opens the **Asistente Manu** drawer with image attachments.

### Credits

Plans give a monthly allowance (free 50 credits, basic 100, standard 250, advanced 500, custom unlimited). The balance renews on the first day of each month (Montevideo time). A generated image costs about 3 credits. Credits are spent by Manu chat and image generation. A request can leave the balance slightly negative; the next monthly renewal restores the allowance.

### WhatsApp

**Aplicaciones de Manu → WhatsApp → Conectar** shows a QR code and a link with a ready message; sending it links the seller's WhatsApp account. The link expires in 15 minutes and works once. One WhatsApp account serves one store at a time (**Cambiar de vuelta a esta tienda** in **Configurar**). Manu answers text and images; it does not start conversations or send order notices. WhatsApp only allows replies within 24 hours of the seller's last message.

### Meta Ads and Google Analytics

The seller connects the account and then selects one ad account or one GA4 property for the store. Until then Manu has no tools for them. Connecting Meta Ads is described in the Meta Ads skill. Analytics tools are read only unless the seller approves.

## Subscription

**Suscripción** (`/suscripcion`) shows the plan, the trial (seven days for new stores) and monthly or annual checkout through Mercado Pago. A suspended store is blocked until it pays. Cancelling stops renewal at the end of the paid period.

## Support tickets

**Soporte** (`/soporte`, or `?ticketId={id}` for one ticket) lists tickets with the Tiendu team. A ticket has a subject and a conversation; the team replies by the next business day. Statuses are Abierto, En progreso, Esperando respuesta del vendedor, Resuelto and Cerrado. Tools: `support-tickets_list`, `_get`, `_create`, `_reply`, `_close`.
