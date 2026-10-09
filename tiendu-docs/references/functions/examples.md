# Function examples

Starting points to adapt, not store data. Mutating examples check `request.method`.

## Create a product from a remote image

Use this when an ERP, PIM or form needs a reusable endpoint. If the seller only wants one product created, do not create a Function: use `images_create-from-url` and `products_create`.

A product does not accept an external image URL, so there are two steps: `POST /images/from-url` returns an `image.id`, then the Function creates the product with that id in `imageIds`.

Secrets:

- `TIENDU_API_KEY`: a store API key.
- `TIENDU_STORE_HANDLE`: the store handle (for example `my-store`).

Make the Function private. It expects a JSON `POST`:

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

Code:

```js
const TIENDU_ORIGIN = 'https://tiendu.uy'

class InputError extends Error {}

async function tienduRequest(env, path, init = {}) {
	const headers = new Headers(init.headers)
	headers.set('Authorization', `Bearer ${env.TIENDU_API_KEY}`)
	if (init.body) headers.set('Content-Type', 'application/json')

	const response = await fetch(
		`${TIENDU_ORIGIN}/api/v3/stores/${env.TIENDU_STORE_HANDLE}${path}`,
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
		if (!env.TIENDU_API_KEY || !env.TIENDU_STORE_HANDLE) {
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
						title,
						handle,
						currency,
						basePriceInCents: input.priceInCents,
						imageIds: [image.id],
						description:
							typeof input.description === 'string' ? input.description : null,
						isListed: false
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

The product is created with `isListed: false`, so it stays a draft for the seller to review. If creation fails after the image import, the Function tries to delete that image in the background.

Never log or hard-code the API key. The bearer that invokes a private Function is consumed by the gateway and removed before the worker; calls to the Tiendu API must use the `TIENDU_API_KEY` secret.
