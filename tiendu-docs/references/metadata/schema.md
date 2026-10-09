# Metadata schema syntax

`jsonSchema` is a **string** containing one JSON object. Tiendu uses it to build and validate the Merchant Center form. It is a small Tiendu dialect, not standard JSON Schema.

Every node needs a `type`; an `object` needs `properties` and an `array` needs `items`. `title` and `description` label each field.

```json
{
  "type": "object",
  "title": "Product details",
  "properties": {
    "brand": { "type": "string", "title": "Brand", "required": true },
    "care": { "type": "string", "title": "Care instructions", "isMultiline": true },
    "colors": {
      "type": "array",
      "title": "Available colors",
      "items": { "type": "string", "title": "Color name" },
      "maxItems": 8
    }
  }
}
```

Stringify the object when sending it through an API.

## Types

| `type` | Required | Optional |
|---|---|---|
| `object` | `properties` | none |
| `array` | `items` | `minItems`, `maxItems`, `uniqueItems` |
| `string` | none | `enum`, `isMultiline`, `minLength`, `maxLength`, `pattern`, `required`, `default`, `example` |
| `number` | none | `minimum`, `maximum`, `exclusiveMinimum`, `exclusiveMaximum`, `multipleOf`, `required`, `default`, `example` |
| `boolean` | none | `default` |
| `color` | none | `required`, `default`, `example` (values are `#RRGGBB`) |
| `image`, `product`, `category` | none | none |

`enum` is a non-empty array of strings; `pattern` is a JavaScript regular expression; `exclusiveMinimum` and `exclusiveMaximum` are booleans.

## Differences from JSON Schema

- `required` is a boolean on a `string`, `number` or `color` field, not an array on the parent.
- `$schema`, `$ref`, `oneOf`, `anyOf` and `additionalProperties` have no effect. Unknown properties are ignored.
