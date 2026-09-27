# Crear y editar anuncios

## Preparación

Confirmá el resultado buscado, producto u oferta, público, ubicación, presupuesto, duración, destino y material visual. Leé la cuenta elegida y los objetos existentes antes de crear duplicados. Comprobá el estado de Pixel, catálogo y página de producto cuando sean relevantes. Escribí texto fiel a la tienda, con propuesta clara y llamada a la acción; evitá promesas no verificadas.

## Imágenes con Tiendu y Meta

1. Para una imagen nueva o editada, activá `images_generate`. El resultado se guarda en la galería Tiendu y devuelve un ID y una URL pública. Si el vendedor solo pidió verla, terminá ahí.
2. Cuando se pidió usarla en un anuncio, activá la herramienta Meta de carga de medios disponible. Si su contrato acepta `upload_source=URL` y `media_type=IMAGE`, entregá la URL pública; usá el `image_hash` u otro identificador devuelto en la creatividad según el esquema actual. Si el contrato admite `image_url`, esa puede ser otra vía. No supongas que el ID de galería Tiendu es un ID de Meta.
3. Si la creatividad usa una imagen generada con IA y el contrato ofrece `self_ai_disclosure`, declarala con `OPT_IN`. Revisá recorte, texto, marca y coherencia con la página de destino.
4. Para ver una imagen de un anuncio existente, buscá su URL pública mediante las herramientas Meta. Si existe, activá `images_create-from-url` para incorporarla a la galería Tiendu y `images_inspect` con el ID devuelto. Si Meta solo entrega hash o una URL inaccesible, explicá que no podés inspeccionar esos píxeles.

## Creación y cambios

1. Seleccioná o creá la campaña y el conjunto adecuados al objetivo. Usá los nombres exactos del índice de herramientas, leé sus esquemas y comprobá la respuesta de cada paso. No inventes campos ni supongas que un presupuesto corresponde a un nivel determinado.
2. Creá la creatividad y luego el anuncio asociado. Dejá el anuncio en pausa mientras verificás destino, texto, imagen, Pixel/dataset, presupuesto y estado de campaña/conjunto/anuncio. Si el vendedor pidió publicarlo, activalo después de la revisión y la autorización correspondiente; Meta puede mantenerlo en revisión.
3. Para editar, leé el objeto actual, cambiá solo los campos necesarios y volvé a consultarlo. Cambiar estado, presupuesto o audiencia puede afectar el gasto y el aprendizaje; explicá el alcance antes de llamar la herramienta.
4. Informá qué quedó creado o modificado, su estado real, cualquier revisión pendiente en Meta y qué observar después de empezar a entregar. Si una llamada falla, detallá qué pasos anteriores sí quedaron aplicados para evitar duplicados al reintentar.
