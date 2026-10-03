# Ejemplos de Funciones

Leé esta referencia cuando necesites adaptar un patrón completo. Estos ejemplos
son puntos de partida, no datos de la tienda.

Los ejemplos que modifican recursos verifican `request.method`. Usá `GET` para
lecturas y elegí `POST`, `PUT`, `PATCH` o `DELETE` según la mutación; una recarga
o un crawler no debería producir efectos secundarios.

## Crear un producto desde una imagen remota

Este patrón sirve cuando un ERP, PIM o formulario externo necesita un endpoint
reusable. Si el vendedor solo pide crear un producto una vez, no crees una
Función: usá `images_create-from-url` y `products_create`
directamente.

La operación tiene dos pasos porque un producto no acepta una URL externa como
imagen:

1. Tiendu importa la URL con `POST /images/from-url` y devuelve un `image.id`.
2. La Función crea el producto usando ese ID en `imageIds`.

Configurá estos secretos:

- `TIENDU_API_KEY`: API key global con acceso a la tienda.
- `TIENDU_STORE_ID`: ID numérico de la tienda, guardado como string.

La Función debe ser privada. Espera un `POST` JSON como:

```json
{
	"title": "Remera azul",
	"handle": "remera-azul",
	"imageUrl": "https://images.example.com/remera-azul.webp",
	"priceInCents": 159000,
	"currency": "UYU",
	"description": "Remera de algodón"
}
```

Código:

```js
const TIENDU_ORIGIN = 'https://tiendu.uy'

class InputError extends Error {}

async function tienduRequest(env, path, init = {}) {
	const headers = new Headers(init.headers)
	headers.set('Authorization', `Bearer ${env.TIENDU_API_KEY}`)
	if (init.body) headers.set('Content-Type', 'application/json')

	const response = await fetch(
		`${TIENDU_ORIGIN}/api/v2/stores/${env.TIENDU_STORE_ID}${path}`,
		{ ...init, headers }
	)
	const text = await response.text()
	let body = null
	try {
		body = text ? JSON.parse(text) : null
	} catch {
		body = text
	}

	if (!response.ok) {
		console.error('Tiendu Admin API error', response.status, body)
		throw new Error(`Tiendu Admin API returned ${response.status}`)
	}
	return body
}

function requiredString(value, field) {
	if (typeof value !== 'string' || !value.trim()) {
		throw new InputError(`${field} is required`)
	}
	return value.trim()
}

export default {
	async fetch(request, env, ctx) {
		if (request.method !== 'POST') {
			return Response.json(
				{ error: 'Method not allowed' },
				{ status: 405, headers: { Allow: 'POST' } }
			)
		}
		if (!env.TIENDU_API_KEY || !env.TIENDU_STORE_ID) {
			console.error('Missing Tiendu API configuration')
			return Response.json(
				{ error: 'Function not configured' },
				{ status: 500 }
			)
		}

		let image
		try {
			const input = await request.json()
			const title = requiredString(input.title, 'title')
			const handle = requiredString(input.handle, 'handle')
			const imageUrl = new URL(requiredString(input.imageUrl, 'imageUrl'))
			if (imageUrl.protocol !== 'https:') {
				throw new InputError('imageUrl must use HTTPS')
			}
			if (!Number.isInteger(input.priceInCents) || input.priceInCents < 0) {
				throw new InputError('priceInCents must be a non-negative integer')
			}
			const currency = input.currency ?? 'UYU'
			if (currency !== 'UYU' && currency !== 'USD') {
				throw new InputError('currency must be UYU or USD')
			}

			image = await tienduRequest(env, '/images/from-url', {
				method: 'POST',
				body: JSON.stringify({
					sourceUrl: imageUrl.href,
					alt: title,
					fileName: null
				})
			})

			try {
				const product = await tienduRequest(env, '/products', {
					method: 'POST',
					body: JSON.stringify({
						input: {
							title,
							handle,
							currency,
							basePriceInCents: input.priceInCents,
							baseCompareAtPriceInCents: null,
							baseWeightInGrams: null,
							imageIds: [image.id],
							description:
								typeof input.description === 'string'
									? input.description
									: null,
							specifications: null,
							videoUrl: null,
							isPhysical: true,
							stock: null,
							isListed: false,
							sku: null
						}
					})
				})

				return Response.json(
					{ ok: true, productId: product.id, imageId: image.id },
					{ status: 201 }
				)
			} catch (error) {
				ctx.waitUntil(
					tienduRequest(env, `/images/${image.id}`, { method: 'DELETE' }).catch(
						cleanupError => console.error('Image cleanup failed', cleanupError)
					)
				)
				throw error
			}
		} catch (error) {
			if (error instanceof InputError || error instanceof SyntaxError) {
				return Response.json({ error: error.message }, { status: 400 })
			}
			console.error('Product import failed', error)
			return Response.json({ error: 'Product import failed' }, { status: 500 })
		}
	}
}
```

La creación usa `isListed: false`: el producto queda como borrador para que el
vendedor lo revise. Si la creación falla después de importar la imagen, la
Función intenta borrar esa imagen en segundo plano.

No registres la API key ni la copies en el código. El bearer que invoca la
Función privada se usa en el gateway y se elimina antes de llegar al worker; la
llamada a la Admin API debe usar el secreto `TIENDU_API_KEY`.
