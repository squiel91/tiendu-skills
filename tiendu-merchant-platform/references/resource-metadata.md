# Resource metadata

Products, collections, blog posts and pages support a `metadata` field for custom JSON: collection banners, article reading times, page callouts or product details. The values live on each record and are returned by its Merchant API and MCP list/get operations. They are independent of SEO fields, content blocks and theme settings.

## Write values

Use the resource's normal create or update operation. No form schema is required for API writes.

| Input | Result |
| --- | --- |
| Omitted on create | `null` |
| Omitted on update | Existing value is preserved |
| `null` | Value is cleared |
| Any other JSON value | Entire value is replaced; objects are not merged |

```bash
curl https://tiendu.uy/api/v3/stores/my-store/collections/24 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"metadata":{"bannerText":"Summer offers","accent":"#ee8844"}}'
```

The same `metadata` field works with [products](api/products/overview.md), [collections](api/collections/overview.md), [pages](api/pages/overview.md) and [blog posts](api/blog-posts/overview.md). MCP uses the existing resource create/update tools, with `metadata` inside their `input`. Read before updating when preserving other keys.

## Configure the editing form

Each store can define one form schema per resource type. A developer provisions it through the authenticated metadata endpoint; the generic store-metadata settings page is hidden.

| Resource | Schema entry key |
| --- | --- |
| Products | `--detailed-product-metadata` |
| Collections | `--detailed-collection-metadata` |
| Blog posts | `--detailed-blog-post-metadata` |
| Pages | `--detailed-page-metadata` |

For example, enable collection metadata editing:

```bash
curl https://tiendu.uy/api/v3/stores/my-store/metadata \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "key":"--detailed-collection-metadata",
    "name":"Collection details",
    "description":"Extra content for collection pages",
    "jsonSchema":"{\"type\":\"object\",\"properties\":{\"bannerText\":{\"type\":\"string\",\"title\":\"Banner text\"},\"accent\":{\"type\":\"color\",\"title\":\"Accent color\"}}}",
    "data":{},
    "isInternal":false,
    "isPublic":false
  }'
```

An existing key returns HTTP 409. Update its schema with `PATCH /api/v3/stores/{storeHandle}/metadata/{key}`, sending `jsonSchema` as a JSON-encoded string. Deleting the schema entry hides the form without deleting resource values. The entry's `data` is not the default or the storage for resource values. `isPublic: false` on this schema entry does not make resource metadata private.

The form uses Tiendu's existing schema dialect:

- Types: `object`, `array`, `string`, `number`, `boolean`, `color`, `image`, `product`, `collection`.
- Objects use `properties`; arrays use `items`; field labels use `title` and help text uses `description`.
- Required string and number fields use `required: true` on the field itself, rather than a parent array. Strings support `enum`, `isMultiline`, `minLength`, `maxLength` and `pattern`.
- Picker values are stored as references such as `{ "__type__": "image", "id": 123 }` or `{ "__type__": "collection", "id": 24 }`. The collection schema type and reference marker are both `collection`. Page and blog-post pickers are not supported.

This is not standard JSON Schema. The panel validates values against the form schema; API and MCP writes accept JSON without enforcing that schema. Picker previews currently have the same limitations as the product editor: stored references may display placeholder labels or an incomplete image preview.

## In the Merchant Center

Open a product, collection, page or blog post and select **Editar metadatos** under **Esenciales**. The button appears only when that resource type has a schema with `jsonSchema` set.

For an existing record, saving the drawer updates metadata immediately and preserves unsaved edits in the surrounding form. For a new record, the drawer prepares the values locally; save the main form to create the record and its metadata together. Leaving before creating the record discards those values.

## Read from the storefront

The Store API exposes `Product.metadata`, `Collection.metadata`, `BlogPost.metadata` and `Page.metadata` as nullable `JSON` fields. Select `metadata` in detail or listing queries; it is fetched only when requested and batches across records. JSON is returned as stored; picker references are not resolved automatically.

```graphql
query CustomContent {
  collection(handle: "summer-offers") { name metadata }
  page(handle: "about-us") { title metadata }
  blogPost(handle: "summer-launch") { title metadata }
}
```

Resource visibility rules also apply to metadata. Public but unlisted collections and pages can still be read by direct handle or ID. Draft blog posts are unavailable. Metadata is storefront-visible whenever its resource is accessible; use it for public content. Collection metadata is not inherited from parents. The virtual `todas` collection reads metadata from its optional stored presentation row, or returns `null` when none exists.

In Theme Kit, resolve a reference during server rendering with a named query. Load the resource's `metadata` in `+page.graphql`, then pass its reference ID to `product(id:)`, `collection(id:)`, `image(id:)`, `page(id:)` or `blogPost(id:)`. The lookup applies the referenced resource's own visibility rules and can return `null`. No browser request is needed. See the [complete Theme Kit example](https://docs.tiendu.uy/themes/data-files#resolve-metadata-references).

Metadata cannot be used to filter or sort the catalog. For custom datasets that are not fields of these resources, use the [store database](store-database/overview.md).
