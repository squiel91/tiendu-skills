# Catálogo de productos y feed

Tiendu ofrece en **Ajustes → Integraciones → Meta Business** una URL de feed XML para importar productos en Meta Commerce Manager. La URL sigue `https://tiendu.uy/stores/{storeId}/products/feed.xml` (o el origen público configurado). Usá la URL que muestra el panel para esa tienda: no inventes `{storeId}` ni reemplaces el origen por el dominio de la tienda.

El feed solo responde para una tienda publicada y lista sus productos públicos. Emite un artículo por variante con precio, imagen y enlace de producto; omite variantes sin precio, imagen o enlace. Su `<g:id>` tiene forma `TIENDU_PRODUCT_VARIANT_ID_{variantId}`. Si hay varias variantes, `<g:item_group_id>` las agrupa como `product-{productId}`. Una variante no publicada puede aparecer como `out of stock`; no supongas que toda variante del feed está disponible para comprar.

## Comprobación del catálogo

1. Preguntá o averiguá qué catálogo y feed usa la tienda. Antes de crear otro, consultá los catálogos, feeds, orígenes de eventos y diagnósticos disponibles en Meta.
2. Verificá que la URL real del feed responda, tenga productos esperados y que Meta informe importaciones recientes. Revisá artículos rechazados, imágenes, precio/moneda, disponibilidad, enlaces de producto, variantes y frescura. Un feed generado correctamente puede fallar al procesarse en Meta. Si falta un producto, comprobá primero que la tienda y el producto sean públicos y que la variante tenga precio, imagen y enlace.
3. Contrastá el `id` de una variante del feed con el `retailer_id` del artículo importado. Para anuncios dinámicos, contrastá también los `content_ids` de eventos del Pixel/dataset con esos IDs. No concluyas que la coincidencia existe sin datos de ambos lados.
4. Si el vendedor quiere conectar el feed, usá el catálogo existente cuando corresponda y creá o asociá un feed solo tras revisar diagnósticos y evitar duplicados. Leé el esquema actual de cada herramienta de Meta y verificá el resultado. El panel también tiene una acción de sincronización manual del catálogo cuando la integración Meta Business está configurada; no confundas esa acción con la importación programada del feed en Meta.

## Mejoras de producto antes de anunciar

- Priorizá productos disponibles, con precio correcto, foto clara, nombre útil y página de destino funcional.
- Revisá que la promesa del anuncio coincida con precio, variantes, envío y disponibilidad reales. No anuncies descuentos ni plazos que no figuren en la tienda.
- Si hay rechazos o artículos faltantes, resolvé su causa antes de recomendar más gasto. Distinguí problemas del dato Tiendu de problemas de ingesta o revisión en Meta.
