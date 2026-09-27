# Medición y Pixel

## Comprobación

1. Identificá la cuenta publicitaria seleccionada y el dataset o Pixel que usa el conjunto de anuncios. No confundas el ID de cuenta, el de dataset y el de catálogo.
2. Consultá los datasets accesibles, sus detalles, calidad y estadísticas con las herramientas Meta disponibles. Leé el Pixel ID de Tiendu con `metadata_get` en Manu (`stores.metadata.get` por MCP) para la clave `--public-config` y comparalo con el dataset de Meta. El campo actual es `data.meta.publicKey`; si falta, el runtime acepta `data.meta.pixelId` y después `data.metaPixelId` como formatos anteriores. Si no tenés acceso a esa lectura, pedile al vendedor que lo vea en **Ajustes → Integraciones → Meta Business → Conversion Tracking**. No busques una clave separada `--public-meta-pixel`.
3. Compará IDs exactos. Si difieren, indicá qué cuenta, dataset y configuración deben revisarse antes de gastar. Si coinciden, verificá eventos recibidos, fechas, origen y diagnósticos; no des por válida la medición solo por el ID.
4. Revisá eventos relevantes para el objetivo (por ejemplo, vista de contenido, carrito, inicio de compra y compra), valor, moneda, duplicación navegador/servidor y coincidencia de `content_ids` con el catálogo. Marcá cada comprobación que las herramientas remotas no permitan realizar.

Tiendu inyecta el Pixel configurado en la tienda pública a través de `meta_tracking_script` y `meta_tracking_noscript` del tema. El script base emite `PageView`; Tiendu también dispone de una vía separada para eventos de Conversions API. La presencia de un ID y de esos hooks no prueba que el recorrido completo esté instrumentado o enviando conversiones. Contrastá los eventos que Meta recibió recientemente con una prueba real cuando sea posible. Una ausencia reciente puede depender de volumen, consentimiento o demora de procesamiento; no atribuyas la causa sin evidencia. No leas ni expongas el token de `--private-config` para comparar IDs.

## Lectura de resultados

- Separá conversiones observadas por Meta de ventas de Tiendu: ventanas de atribución, deduplicación, zona horaria y moneda pueden producir diferencias.
- Para campañas de ventas, no optimices por ROAS o costo por compra si los eventos de compra faltan o son poco confiables. Primero señalá el problema de medición y usá métricas intermedias con esa limitación explícita.
- Si el vendedor pregunta por privacidad o consentimiento, describí la configuración visible y recomendá revisar su política y requisitos aplicables sin afirmar cumplimiento legal.
