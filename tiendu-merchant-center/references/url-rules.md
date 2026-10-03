# Redirecciones y Reescrituras

## Qué hacen

Una **redirección (301)** envía al visitante al destino y cambia la URL del
navegador. Una **reescritura** atiende la ruta desde otro destino de la misma
tienda y mantiene la URL que abrió el visitante.

## Dónde está

Entrá a **Ajustes → Tu tienda → Redirecciones y Reescrituras**:
`/admin/tiendas/{storeHandle}/ajustes/tu-tienda#url-rules`.
Usá **Agregar regla**, o tocá una fila para editarla o borrarla. La lista permite
buscar por **Desde** o **Hacia**.

## Campos

| Campo | Uso |
| --- | --- |
| **Acción** | **Redirección (301)** o **Reescritura**. |
| **Coincidencia exacta** | Marcada: solo la ruta indicada. Desmarcada: esa ruta y sus subrutas, conservando el resto del path. |
| **Desde** | Ruta en esta tienda, empezando con `/`, sin dominio, query ni fragmento. |
| **Hacia** | Ruta local. Una redirección también puede apuntar a una URL externa `http://…` o `https://…`. |

No uses `*`: para un prefijo, escribí `/prendas` y desmarcá **Coincidencia exacta**.
El prefijo coincide con `/prendas` y `/prendas/remera`, pero no con `/prendas-extra`.
Las coincidencias exactas ganan; luego gana el prefijo más largo. Un mismo origen
puede tener una regla exacta y otra por prefijo, pero no dos del mismo tipo.
Las queries entrantes se conservan; sus valores prevalecen sobre los del destino.

## Ejemplos

| Acción | Desde | Hacia | Coincidencia exacta |
| --- | --- | --- | --- |
| Reescritura | `/landing` | `/paginas/landing` | Sí |
| Reescritura | `/prendas` | `/productos` | No |
| Redirección (301) | `/productos` | `/prendas` | No |
| Reescritura | `/calculadora` | `/tiendu/functions/calculadora` | Sí |
| Redirección (301) | `/promo` | `https://example.com/landing` | Sí |

Las dos reglas de prendas trabajan juntas: el link original redirige a
`/prendas/remera`, y esa ruta renderiza el producto. Una reescritura se despacha
una sola vez y no vuelve a evaluar reglas sobre su destino.

No hay nombres de rutas reservados. El destino conserva sus controles de acceso,
rate limits, método, body, cookies y headers. El código de una Función recibe la
URL efectiva del destino. Las reescrituras no permiten dominios externos ni URLs
que comiencen con `//`. Las reglas vivas no se aplican en hosts de preview.

## Enlaces y SEO

Las reglas no cambian los `url`/`publicUrl` de productos, páginas o categorías,
los menús de recursos, el sitemap ni **Ver en la tienda**. El vendedor puede
agregar una redirección desde la ruta original o adaptar links con Liquid o
JavaScript. El canonical lo decide el tema; no lo cambies sin que el vendedor lo
pida. Cambiar un canonical no requiere una Función.

El tilde **Crear redirección de ANTERIOR a NUEVO** al cambiar un handle sigue
creando una redirección exacta; no reemplaza una reescritura del vendedor.
Para redirigir un dominio entero, usá **Ajustes → Tienda online → Dominio**.

## Herramientas de Manu

Usá `url-rules_list`, `url-rules_create`, `url-rules_update` y `url-rules_delete`
(herramientas MCP `stores.url-rules.*`). Los campos son `from`, `to`, `action`
(`redirect`/`rewrite`) y `exactMatch`. Crear omitiendo los dos últimos conserva
el comportamiento anterior: redirección exacta. Actualizar o borrar usa
`urlRuleId`. No crees una Función ni edites código del tema para configurar una
regla que ya está soportada por estas herramientas.
