---
name: tiendu-meta-ads
description: >-
  Usá esta habilidad para ayudar a una tienda Tiendu con Meta Ads: revisar campañas,
  comprobar Pixel y catálogo, preparar imágenes, crear o editar anuncios y evaluar
  resultados. Requiere acceso a Tiendu y a la cuenta publicitaria Meta elegida.
---

# Meta Ads para tiendas Tiendu

Trabajá sobre la cuenta publicitaria elegida para esta tienda. Antes de recomendar cambios, conocé el objetivo comercial, los productos, el destino del anuncio y el período de análisis. Hablá de resultados y decisiones en lenguaje del vendedor.

## Método de trabajo

1. Consultá el catálogo actual de herramientas Meta Ads y sus esquemas: el MCP remoto puede cambiar. En Manu, activá nombres exactos con `manu_activate_tools`; en otro agente, usá las herramientas MCP equivalentes que tenga conectadas. No copies nombres de herramientas de guías externas sin verificarlos.
2. Leé solamente las referencias necesarias para la tarea. En Manu, hacelo con `manu_read_skill_file`:

| Tarea | Referencia |
| --- | --- |
| Comprobar Pixel, dataset, eventos o atribución | `references/medicion.md` |
| Revisar catálogo, feed o anuncios de productos | `references/catalogo.md` |
| Auditar una campaña y proponer cambios | `references/auditoria.md` |
| Crear o editar campaña, conjunto, creatividad o anuncio | `references/anuncios.md` |

3. Contrastá lo que devuelve Meta con la configuración y el catálogo de Tiendu cuando la tarea lo requiera. Distinguí datos observados, hipótesis y recomendaciones.
4. Antes de una escritura, explicá el cambio que intentás hacer. Las herramientas de escritura Meta requieren autorización del vendedor. Después, comprobá el resultado remoto; no deduzcas que un anuncio quedó publicado por haber creado una creatividad.

## Reglas clave

- Verificá que las respuestas remotas correspondan a la cuenta seleccionada antes de atribuirle resultados o confirmar cambios.
- Separá campaña (objetivo y presupuesto, según configuración), conjunto (audiencia, ubicación, optimización) y anuncio (creatividad y destino). Leé el estado de cada nivel antes de modificarlo.
- No prometas ventas ni uses umbrales universales de ROAS, CPA, frecuencia o presupuesto. Evaluá rentabilidad con márgenes, ticket, objetivo y datos de la tienda.
- Una coincidencia de ID de Pixel no demuestra que los eventos de compra funcionen. Un feed accesible no demuestra que sus productos estén aprobados ni que la coincidencia con eventos sea correcta.
- El Pixel de la tienda se configura en Tiendu en `--public-config`, normalmente en `meta.publicKey`; el feed de productos se ofrece en Ajustes → Integraciones → Meta Business. Seguí `references/medicion.md` y `references/catalogo.md` para comprobarlos, sin adivinar valores de otra tienda.
- Podés generar imágenes con `images_generate` y guardarlas en la galería Tiendu, o importar una imagen pública de Meta con `images_create-from-url` y analizarla con `images_inspect`. Para usarlas en Meta seguí `references/anuncios.md`; inspeccioná imágenes existentes solo cuando verlas cambie la decisión.
