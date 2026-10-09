# Metadata

**Metadata** (*metadatos*, *campos personalizados*) is JSON that does not fit the standard fields. It comes in two forms.

## Store metadata

Keyed JSON entries of the store, for values with no dedicated setting (an announcement, integration settings).

| Field | Meaning |
|---|---|
| `key` | Unique key, up to 128 characters; lowercase letters, numbers and hyphens. |
| `name`, `description` | Optional label and explanation. |
| `data` | The JSON value. |
| `jsonSchema` | Optional string with a Tiendu form schema (see [schema syntax](schema.md)). |
| `isPublic` | Lets Liquid and the public endpoint read `data`. |
| `isInternal` | Platform-managed; hidden from merchants. |

Keys starting with `--` are reserved by Tiendu, for example `--detailed-product-metadata`, `--extra-payment-methods` and `--private-config`. Do not create or rename them casually.

Public entries are read in a theme with `{% metadata key: "site-announcement" as announcement %}...{% endmetadata %}`, or at `GET /tiendu/api/metadata/{key}` on the store domain. A missing or private key reads as `null`.

## Product metadata

Extra JSON stored on each product in `product.metadata` (brand, origin, care). It is separate from **Características** (`specifications`).

The Merchant Center shows the **Editar metadatos** button on products only when the store has an entry with the exact key `--detailed-product-metadata` and a valid `jsonSchema`. That entry defines the form; the values live on each product. Keep that entry private (`isPublic: false`). Themes read `product.metadata` directly; the `{% metadata %}` tag does not read it.

To turn the product editor on: create the `--detailed-product-metadata` entry (with a REST call or in the panel; the tools cannot create entries), set its `jsonSchema` as a **string** with an object root, and write values with `products_create` or `products_update` (`input.metadata`).

## Edge cases

- Writes through the API or tools are not validated against `jsonSchema`; only the panel form is. Follow the schema so the seller can keep editing the data.
- `metadata_create` does not exist as a tool; create entries with REST v3 or the panel.
- Image, product and collection picker values are stored as references such as `{ "__type__": "image", "id": 123 }`.

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| Read, update, delete an entry | `metadata_list`, `metadata_get`, `metadata_update`, `metadata_delete` | `GET /metadata`, `GET/PATCH/DELETE /metadata/{metadataKey}` |
| Create an entry | none | `POST /metadata` |
| Product values | `products_get`, `products_create`, `products_update` | `metadata` in the product body |

Where to find it: [Merchant Center](panel.md).
