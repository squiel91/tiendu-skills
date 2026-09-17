# Metadatos de producto

## Qué es

Un **producto** puede guardar JSON extra en `product.metadata` (marca, origen,
cuidados, etc.). Eso **no** es lo mismo que:

- **Características** (`specifications`) — lista nombre/valor de ficha técnica
- **Metadatos de la tienda** — claves en **Ajustes → Desarrollo → Metadatos**,
  leídas en el tema con `{% metadata %}`

El formulario del admin para editar `product.metadata` **solo existe** si hay
un metadato de tienda con la clave exacta `--detailed-product-metadata` **y**
ese metadato tiene `jsonSchema`.

Esa entrada de la tienda es el **esquema**. Los valores de cada producto viven
en el producto, no en el `data` de esa clave.

## Dónde está

| Qué | Dónde |
|-----|--------|
| Esquema (una vez por tienda) | **Ajustes → Desarrollo → Metadatos** → clave `--detailed-product-metadata` |
| Valores (por producto) | Producto → **Editar metadatos** (debajo de título/descripción) |
| En la tienda | `product.metadata` en Liquid; no uses `{% metadata %}` |

Si no ves **Editar metadatos**, falta crear esa clave o le falta el esquema.

## Cómo habilitarlo

1. **Ajustes → Desarrollo → Metadatos** → crear clave `--detailed-product-metadata`.
   Crear claves no está en MCP/OpenAPI; hay que hacerlo en el panel.
2. En modo desarrollador, pegar el `jsonSchema` (dialecto de Tiendu, no JSON
   Schema estándar). También se puede `PATCH` el esquema después con
   `stores.metadata.update`.
3. Abrir un producto: aparece **Editar metadatos**. Guardar escribe
   `stores.products.update` / `stores.products.create` con `input.metadata`.

El `data` de `--detailed-product-metadata` no son los valores del producto
(en el alta igual hay que mandar algo, p. ej. `{}` si el esquema es un objeto).
`isPublic` de esa clave no controla si `product.metadata` se ve en la tienda:
el JSON va con el producto. Dejá esa clave privada.

## Cómo interactuar (Manu / MCP)

| Acción | Herramienta |
|--------|-------------|
| Ver si el esquema existe | `stores.metadata.get` con `metadataKey`: `--detailed-product-metadata` |
| Cambiar el esquema | `stores.metadata.update` (`jsonSchema` es un **string** JSON) |
| Leer valores de un producto | `stores.products.get` → campo `metadata` |
| Escribir valores | `stores.products.create` o `stores.products.update` → `input.metadata` |

La API **no** valida `product.metadata` contra el esquema; el formulario del
admin sí. Respetá el esquema para que el vendedor pueda editar lo mismo.

No uses `stores.metadata.update` para guardar la marca de un producto.

## Esquema (dialecto Tiendu)

`jsonSchema` es un **string** con un objeto. No hay `$ref`, `oneOf` ni
`required` como array: `required` es un **boolean en cada campo**.

Cada nodo tiene `type`. `title` / `description` son etiquetas del admin.

| `type` | Obligatorio extra | Opcional |
|--------|-------------------|----------|
| `object` | `properties` | `title`, `description` |
| `array` | `items` | `minItems`, `maxItems`, `uniqueItems` |
| `string` | — | `enum`, `isMultiline`, `minLength`, `maxLength`, `pattern`, `required`, `default`, `example` |
| `number` | — | `minimum`, `maximum`, `exclusiveMinimum` (bool), `exclusiveMaximum` (bool), `multipleOf` (> 0), `required`, `default`, `example` |
| `boolean` | — | `default` |
| `color` | — | `required`, `default` / `example` en `#RRGGBB` |
| `image` / `product` / `category` | — | `title`, `description` |

Ejemplo:

```json
{
  "type": "object",
  "title": "Ficha detallada",
  "properties": {
    "brand": { "type": "string", "title": "Marca", "required": true },
    "origin": { "type": "string", "title": "Origen" },
    "care": { "type": "string", "title": "Cuidados", "isMultiline": true }
  }
}
```

Pickers se guardan así (en el producto **no** se expanden a objetos completos):

```json
{ "__type__": "image", "id": 123 }
```

## Liquid

```liquid
{% if product.metadata and product.metadata.brand %}
  <p>Marca: {{ product.metadata.brand | escape }}</p>
{% endif %}
```
