# Contrato del runtime

Leé esta referencia antes de crear o modificar el código de una Función.

## Módulo y ciclo de vida

Guardá JavaScript como un módulo workerd nativo:

```js
export default {
	async fetch(request, env, ctx) {
		return new Response('OK')
	}
}
```

- `fetch` debe ser una función y devolver un `Response` o una promesa de
  `Response`.
- Solo se admite JavaScript. No uses TypeScript, JSX, paquetes npm, imports
  externos, APIs de Node, `process`, `Buffer`, `fs` ni `node:*`.
- La fecha de compatibilidad está fijada en `2026-09-15`. No dependas de APIs
  posteriores.
- El módulo se importa al guardar para comprobar sintaxis, imports y el export.
  El handler no se invoca durante esa validación.
- La evaluación top-level debe ser pura y rápida: no hagas `fetch`, no leas
  secretos y no inicialices clientes externos fuera del handler.
- Una referencia inexistente dentro de una rama de `fetch` puede superar la
  validación y fallar recién al invocarse. Escribí defensivamente y revisá logs.

## APIs disponibles

Usá las Web APIs de workerd, entre ellas `Request`, `Response`, `Headers`, `URL`,
`URLSearchParams`, `fetch`, `crypto`, `TextEncoder`, `TextDecoder`, streams,
`FormData`, `Blob`, `atob`, `btoa` y `console`.

No asumas bindings de plataforma. `env` contiene únicamente los secretos que el
vendedor configuró para esa Función, como strings. No existen automáticamente
KV, D1, R2, Durable Objects, filesystem, base de datos ni variables del servidor.

## Request, respuesta y contexto

- `request` conserva método, query, headers y body de la invocación. Si llegó
  mediante una reescritura, URL y path son los del destino efectivo
  `/tiendu/functions/{slug}` (más la subruta), no los del alias público.
- Tiendu valida un endpoint privado antes de ejecutar el worker y elimina el
  encabezado `Authorization` antes de entregar el request al código.
- Devolvé siempre un `Response`. Podés conservar status, headers, cookies,
  redirects, JSON, texto, streams o binarios dentro de los límites.
- `ctx.waitUntil(promise)` permite finalizar trabajo breve después de producir la
  respuesta. Capturá los errores de esa promesa y registralos con `console.error`.
- `console.debug`, `log`, `info`, `warn` y `error` aparecen en Registros y se
  correlacionan con la invocación.

Patrones comunes:

```js
const url = new URL(request.url)
const payload = await request.json()
const token = env.EXTERNAL_API_TOKEN

return Response.json(
	{ ok: true, path: url.pathname, payload },
	{ status: 200, headers: { 'Cache-Control': 'no-store' } }
)
```

No confíes en el input. Comprobá método, `content-type`, campos requeridos,
tamaños y URLs antes de realizar efectos externos. No registres secretos.

Para operaciones que modifican datos, es fuertemente recomendado verificar que
la request tenga el método que corresponda (`POST`, `PUT`, `PATCH` o `DELETE`).
Esto evita especialmente que requests `GET` disparadas por un crawler, un
prefetch o una recarga de página tengan efectos indeseados. Que una Función sea
pública no implica que deba aceptar `GET`.

Por ejemplo, una Función que crea un recurso puede exigir `POST`:

```js
if (request.method !== 'POST') {
	return new Response(null, {
		status: 405,
		headers: { Allow: 'POST' }
	})
}
```

## Red y límites

- `fetch()` solo puede salir a Internet público. Loopback, redes privadas y
  metadata del servidor están bloqueados.
- Límite por invocación: 50 ms de CPU, 15 segundos totales y 20 subrequests.
- Request y response admiten hasta 5 MiB.
- El gateway permite 60 invocaciones por minuto por IP y Función.
- Preferí APIs remotas acotadas, `Promise.all` cuando las operaciones sean
  independientes y `ctx.waitUntil` solo para trabajo prescindible para la
  respuesta.

## Guardado atómico

Create, update, patch y replace validan el módulo completo. Un error conserva la
versión activa anterior. Si dos cambios dependen entre sí, envialos juntos en un
solo unified diff con múltiples hunks. Leé primero y enviá siempre
`expectedSha256` para evitar pisar una edición concurrente.
