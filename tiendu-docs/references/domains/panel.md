# Domains in the Merchant Center

**Ajustes → Tienda → Dominios** (`/admin/tiendas/{storeHandle}/ajustes/tienda/dominios`). The line under the title is "La dirección donde tus clientes encuentran tu tienda."

Use these screens and labels to guide the merchant. There are no tools that change a domain.

## List

- **Agregar dominio** opens the search. With no domains yet, the empty state is **Todavía no tenés un dominio** and the same button.
- The primary domain is the card **Tu tienda está en**, with **Administrar** and **Abrir tienda**.
- Other domains are cards. While one is pending, the card shows the steps (Pago, Registro, Activación, Funcionando, or the nameserver or CNAME steps). The page refreshes on its own every 15 seconds.
- An unpaid purchase shows **Pagar** and **Cancelar**.

## Agregar un dominio

`/ajustes/tienda/dominios/agregar`. Title **Agregar un dominio**. "Escribí el dominio que querés. Si está libre lo comprás; si ya es tuyo, lo conectás."

The field is **Dominio** (placeholder `mitienda.uy`). An empty field shows **Sugerencias para tu tienda**; a search shows **Resultados**.

| Label on the row | Button |
|---|---|
| **Disponible** or **Disponible · primer año incluido en tu plan** | **Comprar** |
| **Disponible · lo registramos a mano en hasta 24 horas** | **Reservar** |
| **Ya está registrado. ¿Es tuyo? Conectalo a tu tienda.** | **Conectar** |
| **Ya está en tu tienda** | **Ver** |

The footnote: "Los dominios .uy se registran a tu nombre. Los planes Estándar y Avanzado incluyen el primer año de un dominio."

## Comprar

Title **Comprar {dominio}**. "Queda a tu nombre. Tiendu figura como contacto técnico y lo configura por vos."

- **Primer año** shows the price with **IVA incluido**, or **Incluido en tu plan**.
- **Renovación anual** shows the yearly renewal, IVA included.
- **Titular del dominio**: **Nombre**, **Apellido**, **Empresa o razón social** (optional), **Dirección**, **Ciudad**, **Departamento**, **Código postal**, **Teléfono**, **Email**. "Estos datos figuran en el registro de NIC.uy."
- The button is **Registrar sin costo** or **Pagar {precio} con Mercado Pago**.

Returning from Mercado Pago lands back on the domains list.

## Conectar

Title **Conectar {dominio}**. Tiendu first shows where the DNS is today.

- **Tiendu administra el DNS** — "Cambiás los nameservers en tu proveedor (Antel, NIC.uy) y listo." When records were found, **Registros que vamos a copiar** lists them with checkboxes. The note says more records can be added later from **Registros DNS**.
- **Mantener mi DNS actual** — "Agregás un registro CNAME en tu proveedor de DNS." Email is left as it is.
- The matching option is badged **Recomendado**.
- **Conectar dominio** continues to the detail page.

## Detail

`/ajustes/tienda/dominios/{domainId}`. Tabs, when they apply: **Estado**, **Correo**, **Registros DNS**, **Ajustes**, **Facturación** (`?tab=estado`, `correo`, `dns`, `ajustes`, `facturacion`).

**Estado**

- A pending purchase: **Falta el pago** and **Pagar con Mercado Pago**.
- While Tiendu is working: **Estamos activando tu dominio**.
- Nameservers: **Cambiá los nameservers**, then the four steps (open the registrar, find servidores DNS or nameservers, replace them with the two values, save). Each value has **Copiar**.
- CNAME: the steps are open the DNS panel, create the CNAME (nombre and destino, each with **Copiar**), save. The root-domain note explains ALIAS, ANAME, or connecting `www` and redirecting the root.
- **Ya lo hice, revisar** checks now. After a check the button becomes **Revisar de nuevo**. "Revisamos solos cada pocos minutos y te avisamos por email." An external domain warns that it is removed after 14 days if it is never configured.
- A live domain has **Abrir tienda**. **Usar para correo** opens the **Correo** tab when Tiendu hosts the DNS.

**Correo**

**Google Workspace** ("Gmail con tu dominio"), **Microsoft 365** ("Outlook con tu dominio"), **Zoho Mail** ("Tiene un plan gratuito"), **Otro proveedor** ("Agregás los registros a mano"). **Configurar {proveedor}** writes the mail records. Then paste the DKIM key and **Guardar clave**, or for Microsoft use **Ir a Registros DNS**. **Otro proveedor** only sends them to **Registros DNS**.

**Registros DNS**

Columns **Tipo**, **Nombre**, **Valor**. **Agregar registro** asks for type, **Nombre** (`@` is the root, or a label such as `mail`) and **Valor**. The storefront `@` and `www` records cannot be edited or deleted.

**Ajustes**

- **Dominio principal** — "La dirección que usa tu tienda en links, emails y buscadores." **Hacer principal** when this domain is live and is not already primary.
- **Redirigir a otra dirección** — "Quien entre a este dominio llega a otra URL, en lugar de a tu tienda." Save the URL, or **Quitar**.
- **Deshabilitar** — "Deja de mostrar tu tienda sin borrar la configuración." **Habilitar** — "Vuelve a mostrar tu tienda en este dominio."
- **Eliminar de Tiendu**. Bought in Tiendu: "Deja de apuntar a tu tienda y borramos su DNS. Sigue registrado a tu nombre hasta que venza." Connected: "Deja de apuntar a tu tienda. El dominio sigue siendo tuyo en tu proveedor."

**Facturación** (bought domains only): **Registrado**, **Vence**, **Renovación**, **Primer año**, **Titular**, **Contacto técnico** (Tiendu).

## Reserva a mano

**Reservar** is for an available name Tiendu does not register automatically. The detail page **Completá el pago** gives the transfer instructions (BROU) and a **WhatsApp** link. Status stays **Pendiente de pago** until someone at Tiendu activates it, within 24 hours of payment.
