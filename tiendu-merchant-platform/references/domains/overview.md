# Domains

A domain is the hostname shoppers use to open the store (`mitienda.uy`). The free hostname `{handle}.tiendu.uy` is always there. Extra domains are bought or connected from **Ajustes → Tienda → Dominios**.

There are no domain tools to call, and the steps below are the ones the panel shows.

## Which path

| What the merchant wants | What the search says | What they do |
|---|---|---|
| A free `.uy` name (`mitienda.uy`) | **Disponible** and **Comprar** | Pay, or register free when the plan includes it. Tiendu registers it at NIC.uy and configures DNS. |
| A domain they already own, and Tiendu should host the DNS | **Conectar**, then **Tiendu administra el DNS** | They replace the nameservers at their registrar. Tiendu connects the apex and `www`. |
| A domain they already own, and DNS stays at their provider | **Conectar**, then **Mantener mi DNS actual** | They add one CNAME. Their existing email records stay where they are. |
| Any other extension (`.com`, `.com.uy`, `.org`, …) that is still available | **Reservar** | Tiendu registers it by hand within 24 hours. Payment is a bank transfer, not Mercado Pago. |

A name with no dot is searched as `{name}.uy`, `{name}.com.uy` and `{name}.com`. An empty box suggests names from the store handle. **Ya está en tu tienda** opens the domain they already have. **Ya lo usa otra tienda de Tiendu** cannot be bought or connected.

## Buying a `.uy` domain

Only a second-level `.uy` name (`mitienda.uy`, not `mitienda.com.uy`) is registered automatically.

- First year: **UYU 490**, IVA included. Renewal: **UYU 690** per year, IVA included. Renewal is not charged automatically.
- A store on a paid **Estándar** or **Avanzado** plan gets the first year of one domain free (**Incluido en tu plan**, button **Registrar sin costo**). Free, Básico and trial stores pay. The benefit is used once.
- The form **Titular del dominio** is the NIC.uy registrant (name, surname, optional company, address, city, department, postcode, phone, email). Tiendu is the technical contact and sets up the domain.
- Nothing is registered before payment. **Pagar … con Mercado Pago** opens Checkout Pro. An unpaid checkout can be cancelled from the domains list; it expires after 48 hours.
- After payment the status moves through **Registrando** and **Activando** to **Funcionando**. The merchant does not change nameservers. A failed registration is refunded and the domain does not stay on the store.
- **Facturación** shows when it was registered, when it expires, the renewal price and the registrant.

## Connecting a domain they own

**Conectar dominio** offers two options. The one marked **Recomendado** matches how the domain is set up today.

**Tiendu administra el DNS.** The merchant replaces the nameservers at the registrar (Antel, NIC.uy, or whoever registered it) with the two values on the screen. Tiendu copies the email and other records it found; the merchant unchecks any that should not be copied. `www` is connected with the apex and redirects to it. It does not appear as its own card.

**Mantener mi DNS actual.** The merchant creates one CNAME at their DNS provider. The screen shows the name and the destination (`stores.tiendu.uy`). Their email records are left untouched. On the root of the domain, a provider that rejects a CNAME needs an ALIAS or ANAME to the same destination, or they connect `www` and redirect the root to it.

While the merchant still has to act, the status is **Esperando tus nameservers** or **Esperando el registro CNAME**. **Ya lo hice, revisar** checks immediately; Tiendu also checks every few minutes and emails when it is live. An external domain still pending after 14 days is removed from the store. A reminder goes out once after 3 days.

## After it is live

- **Principal** is the hostname used in links, emails and search. **Hacer principal** on another live domain switches it. The card says **Tu tienda está en**.
- **Redirigir a otra dirección** answers every request with a 301 to that URL and keeps the path and query. **Quitar** removes the redirect.
- **Deshabilitar** stops showing the store on that hostname and keeps the configuration. **Habilitar** turns it back on. `www` follows the apex.
- **Eliminar** disconnects the domain from the store. A domain bought in Tiendu stays registered to the merchant until it expires. A domain they already owned stays at their registrar. A domain that is still being registered cannot be deleted yet.

## Email and DNS

**Correo** and **Registros DNS** exist when Tiendu hosts the DNS (a purchased `.uy` domain, or **Tiendu administra el DNS**). A CNAME connection keeps email at the merchant's provider, so those tabs are absent.

**Correo** offers **Google Workspace**, **Microsoft 365**, **Zoho Mail** and **Otro proveedor**. **Configurar** writes the MX and SPF records. Google and Zoho then need the DKIM key pasted from their console (**Guardar clave**). Microsoft uses two CNAME records that the merchant copies into **Registros DNS**. The checklist shows MX, SPF, DKIM and DMARC.

**Registros DNS** lists A, AAAA, CNAME, MX, TXT, SRV and CAA records. **Agregar registro** uses `@` for the root. The storefront records Tiendu created for `@` and `www` stay locked.

## In the Merchant Center

**Ajustes → Tienda → Dominios** (`/admin/tiendas/{storeHandle}/ajustes/tienda/dominios`).

| Screen | Controls and location |
| --- | --- |
| Domains list | **Agregar dominio** opens the search. The primary card is **Tu tienda está en**, with **Administrar** and **Abrir tienda**. Pending purchases show **Pagar** and **Cancelar**. |
| Add a domain | `/ajustes/tienda/dominios/agregar`. Search by domain; an empty field shows suggestions. **Comprar**, **Reservar**, **Conectar** or **Ver** follows the current state. |
| Purchase | **Comprar {dominio}** collects **Titular del dominio** and offers **Registrar sin costo** or **Pagar … con Mercado Pago**. Returning from payment opens the list. |
| Connect | **Conectar {dominio}** offers **Tiendu administra el DNS** and **Mantener mi DNS actual**, with the matching option marked **Recomendado**. |
| Domain detail | `/ajustes/tienda/dominios/{domainId}` has **Estado**, **Correo**, **Registros DNS**, **Ajustes** and **Facturación** when applicable. |

In **Estado**, **Ya lo hice, revisar** checks the nameservers or CNAME immediately. **Correo** configures the provider and DKIM. **Registros DNS → Agregar registro** uses `@` for the root; Tiendu's storefront records remain locked. **Ajustes** contains **Hacer principal**, redirect, enable/disable and delete actions. **Facturación** shows registration, expiry, renewal and registrant details for purchased domains.

**Reservar** opens transfer instructions for manual registration and a WhatsApp link to Tiendu. The status stays **Pendiente de pago** until Tiendu activates it.
