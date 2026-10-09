# Product images

- A product has an ordered gallery in `imageIds`, up to **128** images. The first image is the cover.
- Images come from the store **gallery**. Create one from a public HTTPS URL with `images_create-from-url` (jpeg, png, webp, gif or svg), or upload one in the Merchant Center; then use its `id`.
- **`imageIds` replaces the whole gallery.** To add one image, send the current ids plus the new id (read them with `products_get`).
- A variant can have its own cover image (`coverImageId`).
- Product images are also used by collections, pages and blog posts through the same `id`; never copy a seller photo into a theme's `assets/`.
- `images_delete` deletes the image file itself: everything that used it (products, collections, pages) loses it. Remove an image from one product by updating that product's `imageIds` instead.

Generating and inspecting images are tools of Manu, the in-app assistant, and are not part of the public MCP.
