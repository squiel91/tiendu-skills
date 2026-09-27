# Catálogo de productos y feed

Tiendu ofrece en **Ajustes → Integraciones → Meta Business** una URL de feed XML para importar productos en Meta Commerce Manager. La URL sigue `/stores/{storeId}/products/feed.xml` en el dominio público de Tiendu. Cada variante publicada en el feed tiene un ID con forma `TIENDU_PRODUCT_VARIANT_ID_{variantId}`. Para el vendedor, mostrá la URL real de su tienda obtenida de Tiendu; no inventes `{storeId}`.

## Comprobación del catálogo

1. Preguntá o averiguá qué catálogo y feed usa la tienda. Antes de crear otro, consultá los catálogos, feeds, orígenes de eventos y diagnósticos disponibles en Meta.
2. Verificá que el feed responda, tenga productos esperados y que Meta informe importaciones recientes. Revisá artículos rechazados, imágenes, precio/moneda, disponibilidad, enlaces de producto, variantes y frescura. Un feed generado correctamente puede fallar al procesarse en Meta.
3. Contrastá el `id` de una variante del feed con el `retailer_id` del artículo importado. Para anuncios dinámicos, contrastá también los `content_ids` de eventos del Pixel/dataset con esos IDs. No concluyas que la coincidencia existe sin datos de ambos lados.
4. Si el vendedor quiere conectar el feed, usá el catálogo existente cuando corresponda y creá o asociá un feed solo tras revisar diagnósticos y evitar duplicados. Leé el esquema actual de cada herramienta de Meta y verificá el resultado.

## Mejoras de producto antes de anunciar

- Priorizá productos disponibles, con precio correcto, foto clara, nombre útil y página de destino funcional.
- Revisá que la promesa del anuncio coincida con precio, variantes, envío y disponibilidad reales. No anuncies descuentos ni plazos que no figuren en la tienda.
- Si hay rechazos o artículos faltantes, resolvé su causa antes de recomendar más gasto. Distinguí problemas del dato Tiendu de problemas de ingesta o revisión en Meta.
