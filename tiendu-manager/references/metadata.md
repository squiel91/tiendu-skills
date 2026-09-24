# Store and product metadata

Use this reference for store-level JSON metadata and per-product `metadata` values. They are separate data surfaces.

## Merchant API v3

The public REST API uses the store handle and a store-owned API key:

```text
https://tiendu.uy/api/v3/stores/{storeHandle}
Authorization: Bearer <store-api-key>
```

Create API keys in **Merchant Center → store → Ajustes → Desarrollo → Claves de API**. Keep keys on the server; never put them in storefront JavaScript.

Merchant API request bodies are flat JSON objects. Single-resource requests return the resource directly; list requests return a `data` array and `pagination` object.

## Store metadata

Store metadata holds JSON values under stable keys. The current endpoints are:

| Method | Path |
|--------|------|
| `GET` | `/metadata` |
| `POST` | `/metadata` |
| `GET` | `/metadata/{metadataKey}` |
| `PATCH` | `/metadata/{metadataKey}` |
| `DELETE` | `/metadata/{metadataKey}` |

Keys are at most 128 characters and use lowercase letters, numbers, and hyphens; reserved keys may begin with `--`.

| Field | Meaning |
|-------|---------|
| `key` | Stable key identifying the entry |
| `name`, `description` | Optional display name and notes |
| `data` | Stored JSON value |
| `jsonSchema` | Optional string containing a Tiendu form schema |
| `isPublic` | Allows Liquid and the public Store API to read `data` |
| `isInternal` | Hides the entry from Merchant API v3 list and get responses |

Create requests must include `key`, `data`, `isInternal`, and `isPublic`. Optional `name`, `description`, and `jsonSchema` may be `null`:

```bash
curl -X POST 'https://tiendu.uy/api/v3/stores/my-store/metadata' \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"key":"site-announcement","name":"Announcement","description":null,"jsonSchema":null,"data":{"message":"Welcome"},"isInternal":false,"isPublic":true}'
```

MCP exposes `stores.metadata.list`, `stores.metadata.get`, `stores.metadata.update`, and `stores.metadata.delete`. MCP does not create metadata entries; use Merchant API v3 or the Merchant Center.

Only public store metadata can be read in Liquid:

```liquid
{% metadata key: "site-announcement" as announcement %}
  {% if announcement %}
    <aside>{{ announcement.message | escape }}</aside>
  {% endif %}
{% endmetadata %}
```

The public Store API exposes the same value at `/tiendu/api/metadata/{metadataKey}` on the store domain. This tag and endpoint read **store metadata**, not product metadata.

## Product metadata

Each product can store its own JSON in `product.metadata`. This is separate from store metadata and from product **Características** (`specifications`). The Merchant Center editor for product metadata appears only when the store has the exact metadata key `--detailed-product-metadata` with a non-empty `jsonSchema`.

The reserved store entry holds the form schema. Product values stay on each product:

| Location | Stores |
|----------|--------|
| `--detailed-product-metadata.jsonSchema` | Form definition as a JSON string |
| `--detailed-product-metadata.data` | Not used for product values; provide a JSON value when creating the entry |
| `product.metadata` | Per-product values |

Keep the schema entry private unless its own `data` should be public. `isPublic` does not control visibility of `product.metadata`; that value is returned as part of the product.

Example schema:

```json
{
  "type": "object",
  "title": "Product details",
  "properties": {
    "brand": { "type": "string", "title": "Brand", "required": true },
    "origin": { "type": "string", "title": "Origin" },
    "care": { "type": "string", "title": "Care instructions", "isMultiline": true }
  }
}
```

Send `jsonSchema` as a string, such as `JSON.stringify(schema)`. The product endpoints are:

| Method | Path |
|--------|------|
| `GET` | `/products/{productId}` |
| `POST` | `/products` |
| `PATCH` | `/products/{productId}` |

For example, update values with a flat Merchant API v3 body:

```bash
curl -X PATCH 'https://tiendu.uy/api/v3/stores/my-store/products/123' \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"metadata":{"brand":"Acme","origin":"Uruguay"}}'
```

MCP agents can use `stores.products.get`, `stores.products.create`, and `stores.products.update`. API writes do not validate values against `jsonSchema`; the Merchant Center form does. Follow the schema so merchants can edit the same data.

In Liquid, read product values directly:

```liquid
{% if product.metadata and product.metadata.brand %}
  <p>Brand: {{ product.metadata.brand | escape }}</p>
{% endif %}
```

Do not use `{% metadata %}` for product values. Image, product, and category pickers remain compact references in `product.metadata`:

```json
{ "__type__": "image", "id": 123 }
```

## Schema dialect

`jsonSchema` is a string containing one JSON object in Tiendu's small schema dialect, not standard JSON Schema.

| `type` | Required fields | Optional fields |
|--------|-----------------|-----------------|
| `object` | `properties` | `title`, `description` |
| `array` | `items` | `title`, `description`, `minItems`, `maxItems`, `uniqueItems` |
| `string` | — | `enum`, `isMultiline`, `minLength`, `maxLength`, `pattern`, `required`, `default`, `example`, `title`, `description` |
| `number` | — | `minimum`, `maximum`, `exclusiveMinimum`, `exclusiveMaximum`, `multipleOf`, `required`, `default`, `example`, `title`, `description` |
| `boolean` | — | `default`, `title`, `description` |
| `color` | — | `required`, `default`, `example`, `title`, `description` |
| `image`, `product`, `category` | — | `title`, `description` |

`required` is a boolean on supported fields, not an array on the parent object. Standard JSON Schema keywords such as `$schema`, `$ref`, `oneOf`, `anyOf`, and `additionalProperties` have no effect. API writes are not checked against the schema; validate integration data separately when needed.

For the full current contract, see the [Metadata API reference](https://docs.tiendu.uy/api/reference/metadata/overview), [schema syntax](https://docs.tiendu.uy/metadata/schema), and [product metadata guide](https://docs.tiendu.uy/metadata/product-metadata).
