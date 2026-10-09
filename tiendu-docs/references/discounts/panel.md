# Coupons in the Merchant Center

Menu **Marketing → Cupones** (`/admin/tiendas/{storeHandle}/cupones`). **Agregar** opens `/cupones/nuevo`; an existing coupon opens at `/cupones/{couponId}`. The list can be searched by name or code, filtered (**Mostrar todos**, Activo, Archivado) and shows uses as `current / maximum` or `∞`.

## Editor

| Section | What it holds |
|---|---|
| Esenciales | **Nombre**, **Código** and the **Enlace para compartir** (`{store}?cupon=CODE`), enabled only when the coupon is active and saved. |
| Descuento | Choose **Porcentaje** (percentage and optional **Monto tope de descuento**) or **Monto fijo**. |
| Condiciones | **Monto mínimo de compra**, **Cantidad máxima de usos** (∞ by default) and **Con expiración** with its date. |
| Estado | **Activo** or **Inactivo**. The list calls inactive coupons Archivado. |
