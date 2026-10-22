# Function examples

Starting points to adapt, not store data. Mutating examples check `request.method`.

## Create a product from a remote image

Use this when an ERP, PIM or form needs a reusable endpoint. If the seller only wants one product created, do not create a Function: use `images_create-from-url` and `products_create`.

A product does not accept an external image URL, so there are two steps: `tools['images_create-from-url']` returns an `image.id`, then `tools.products_create` creates the product with that id in `imageIds`.

Request `requestedTools: ['images_create-from-url', 'products_create']` when creating or updating the Function. The merchant owner or a platform administrator must grant both permissions. The Function needs no Tiendu API-key or store-handle secrets; its store identity is fixed by the server.

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
class InputError extends Error {}

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

			image = await tools['images_create-from-url']({
				sourceUrl: imageUrl.href,
				alt: title,
				fileName: null
			})
			const product = await tools.products_create({
				input: {
					title,
					handle,
					currency,
					basePriceInCents: input.priceInCents,
					imageIds: [image.id],
					description: typeof input.description === 'string' ? input.description : null,
					isListed: false
				}
			})
			return Response.json(
				{ ok: true, productId: product.id, imageId: image.id },
				{ status: 201 }
			)
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

The product is created with `isListed: false`, so it stays a draft for the seller to review. The two tool calls are separate operations: if product creation fails, inspect the product and imported image before retrying or removing anything. A timeout can leave an unknown outcome.

The bearer that invokes a private Function is consumed by the gateway and removed before the worker. It is separate from the merchant-granted tool permissions.
