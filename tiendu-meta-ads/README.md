# Tiendu Meta Ads

Skill para un agente conectado a una tienda Tiendu y al MCP de Meta Ads. Ayuda a comprobar la medición, revisar el feed y catálogo de productos, auditar campañas y preparar anuncios acordes a la tienda.

- El Pixel ID de Tiendu se lee de `--public-config` → `meta.publicKey` y se compara con el dataset de Meta.
- El feed XML se obtiene en **Ajustes → Integraciones → Meta Business**. Su URL pública es `/stores/{storeId}/products/feed.xml` y sus IDs de variante siguen `TIENDU_PRODUCT_VARIANT_ID_{variantId}`.
- Para creatividades, el agente puede generar una imagen y guardarla en la galería Tiendu antes de cargarla a Meta. También puede importar una imagen pública de Meta a la galería para inspeccionarla visualmente.

Leé [SKILL.md](./SKILL.md) para el método de trabajo y sus referencias por tarea. En Manu, la habilidad aparece cuando hay una cuenta publicitaria elegida y un catálogo de herramientas Meta disponible; sus instrucciones se cargan cuando Manu la solicita.
