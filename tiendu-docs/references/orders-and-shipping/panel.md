# Orders and logistics in the Merchant Center

## Orders

Menu **Ventas → Pedidos** (`/admin/tiendas/{storeHandle}/pedidos`). Each order opens at `/pedidos/{orderId}`, with status changes, shipping details, notes and a print view (`/imprimir`). Orders needing an action are highlighted.

## Customers and carts

**Ventas → Clientes** and **Ventas → Carritos**: see the customers and reviews guide.

## Payments

**Ajustes → Negocio → Cobros** (`/ajustes/negocios/cobros`): **Mercado Pago** (Conectar, Desconectar, **Ajuste de precio**) and **Transferencias bancarias** (**Agregar medio de pago**).

## Logistics

**Ajustes → Negocio → Logística** (`/ajustes/negocios/entregas`):

| Section | What it holds |
|---|---|
| Preparación y operación | **Días de preparación**, **Días operativos**, **Hora de corte**, **Zona horaria**. |
| Retiro en persona | **Activar retiro en persona**, **Info. de retiro**, **Link en el mapa**. |
| Servicios de entrega | **Agregar courier** / **Seleccionar couriers**, **Envío gratis desde**, **Pago al recibir**. |
| Envío personalizado | **Activar envío personalizado**, **Nombre de envío**, **Zonas de envío** (**Agregar zona**: precio fijo or escalonado por peso, tiempo máximo de entrega, días de entrega, **Precio de orden mínimo para envío gratis**). |

## Auto-confirmation

**Ajustes → Negocio → General**: **Confirmación automática de pedidos** (**Activar confirmación automática**) confirms paid orders automatically.
