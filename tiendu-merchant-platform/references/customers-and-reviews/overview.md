# Customers and reviews

## Customers

A **customer** (*cliente*) is a shopper who has placed an order or saved account data in the store. It holds name, surname, email, phone, identification (type and number) and saved addresses, and links to its orders (`orderCount`). Customers are created by checkout; the API and tools read them (list, get, addresses) but do not create or edit them. The Merchant API customer list includes people with at least one order in this store; a shopper account alone does not make them appear in that list.

`customers_list` supports pagination, `search` by name or email, and `from`/`to` on the registration date.

## Reviews

A **review** (*reseña*) is a product rating with text and optional photos. Fields:

| Field | Meaning |
|---|---|
| `rating` | Stars, 1 to 5. |
| `content`, `authorName` | The text and the name shown. |
| `isVerifiedPurchase` | A manual flag set by the store. It can be true for a purchase made outside Tiendu. |
| `isListed` | `true` shows the review on the storefront; `false` hides it (shown as Sin publicar). |
| `createdAt` | ISO 8601 or `YYYY-MM-DD`; defaults to now. Useful when importing reviews from elsewhere. |
| `imageIds` | Up to 6 photos. |

The store can add, edit, hide and delete reviews, for example to import reviews from another platform. A review notification email can be enabled in **Ajustes → Negocio → General → Notificaciones** ("Nueva reseña publicada").

## Interfaces

| Task | Tool | REST API |
|---|---|---|
| Customers | `customers_list`, `customers_get`, `customers_addresses_list`, `customers_addresses_get` | `GET /customers`, `/customers/{customerId}`, `/customers/{customerId}/addresses` |
| Reviews of the store | `reviews_list` | `GET /reviews` |
| Reviews of a product | `products_reviews_create`, `products_reviews_update`, `products_reviews_delete` | `/reviews`, `/reviews/{reviewId}` |

## In the Merchant Center

### Customers

**Ventas → Clientes** (`/admin/tiendas/{storeHandle}/clientes`). The list filters by **Fecha de registro** (from, to or a range). A customer opens at `/clientes/{customerId}` with personal and identification data (**DNI / CI / RUT**), their orders, saved addresses and quick contact links (**Escribir email**, **Escribir al WhatsApp**).

### Reviews

**Ventas → Reseñas** (`/admin/tiendas/{storeHandle}/reseñas`). Search by product name or product handle, sort by date or rating, and filter Todas, Publicadas or Sin publicar. **Agregar** creates one (product, author name, rating, content, **Compra verificada**, up to 6 photos, status Activo or Archivado).

## API reference

[Customers REST API](../api/customers/overview.md), [Reviews REST API](../api/reviews/overview.md).
