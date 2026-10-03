---
name: tiendu-functions
description: Crear, editar y diagnosticar endpoints JavaScript server-side de Tiendu, incluidos aliases mediante reglas de URL para redirecciones y reescrituras. Cargá este skill solo cuando el pedido requiera una Función, endpoint o integración con código; no para operaciones normales que ya tengan herramientas de Tiendu.
---

# Funciones de Tiendu

Las Funciones son una vía de escape para integraciones y comportamiento
server-side personalizado. No las propongas ni cargues para tareas normales del
panel: si el vendedor solo quiere crear un producto, editar stock, subir una
imagen o consultar pedidos, usá directamente las herramientas existentes.

Usá una Función cuando el resultado deba quedar como un endpoint HTTP reusable,
recibir llamadas de un sistema externo o coordinar una integración que no pueda
resolverse con una operación normal de Tiendu.

## Antes de escribir código

- Leé `references/runtime-contract.md` cuando vayas a crear o modificar código.
- Leé `references/examples.md` solo cuando necesites un patrón de integración
  completo. Adaptá los ejemplos; no copies secretos, IDs ni contenido supuesto.
- Las Funciones se validan con workerd y se activan inmediatamente al guardar.
  Si la validación falla, informá el diagnóstico; la versión activa anterior no
  cambia. No existe un paso separado de deploy.

El módulo mínimo es:

```js
export default {
	async fetch(request, env, ctx) {
		return Response.json({ ok: true })
	}
}
```

Para operaciones con efectos secundarios, recomendá fuertemente comprobar
`request.method` y devolver `405` con `Allow` cuando no corresponda. En
particular, un `GET` invocado por una recarga o crawler no debería modificar
datos. El contrato y el ejemplo están en `references/runtime-contract.md`.

## Edición eficiente

1. `functions_list` para ubicar la función.
2. `functions_code_search` y lecturas acotadas con
   `functions_code_read`.
3. `functions_code_patch` con el `expectedSha256` leído. Reuní en un
   único diff con múltiples hunks los cambios que solo son válidos en conjunto.
4. Usá `functions_code_replace` únicamente para una reescritura completa.

La lista no incluye código. Para metadatos usá `functions_get` y
`functions_update`; no envíes todo el código mediante `update` durante
una edición normal. Crear, actualizar, patch, replace y eliminar son escrituras
con aprobación.

## URL y acceso

La URL es `https://{dominio}/tiendu/functions/{slug}` y admite un path posterior.
El slug es único por tienda y usa minúsculas, números y guiones. Un endpoint
público no requiere credenciales. Uno privado requiere `Authorization: Bearer`
con una API key global de un usuario con acceso a la tienda. El código de la
Función nunca recibe ese encabezado `Authorization`.

Para darle un alias como `/calculadora`, usá `url-rules_create` con `from:
'/calculadora'`, `to: '/tiendu/functions/calculadora'`, `action: 'rewrite'` y
`exactMatch: true`. Desmarcá la coincidencia exacta si necesitás conservar subrutas.
No uses `*` ni un hostname. El alias conserva método, body, query y controles de
acceso; el worker y los registros ven la URL efectiva `/tiendu/functions/…`.
No hace falta cambiar el código de la Función para agregar el alias.

## Secretos

- Listá únicamente nombres y fechas con `functions_secrets_list`.
- Creá, reemplazá o eliminá con `secrets.create`, `secrets.update` y
  `secrets.delete`; requieren aprobación.
- Nunca intentes recuperar ni afirmar el valor de un secreto: Tiendu no lo
  devuelve después de guardarlo.
- Los nombres usan `UPPERCASE_WITH_UNDERSCORES`. Hay hasta 100 secretos por
  función y cada valor admite 64 KiB.

## Diagnóstico

Usá `functions_invocations_list`, luego
`functions_invocations_get` para inspeccionar request/response completos,
y finalmente `functions_logs_list` para correlacionar `console.*` y
excepciones por ID de invocación. Los datos se retienen siete días. Filtrá logs
por nivel o texto antes de ampliar una búsqueda.
