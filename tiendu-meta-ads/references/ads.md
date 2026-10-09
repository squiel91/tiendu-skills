# Create and edit ads

## Prepare

Confirm the desired result, product or offer, audience, placement, budget, duration, destination and visual material. Read the selected account and existing objects before creating duplicates. Check Pixel, catalog and the product page when relevant. Write copy faithful to the store with a clear proposition and call to action, and no unverified promises.

## Images between Tiendu and Meta

1. To create or edit an image, use `images_generate` (Manu only). It saves to the Tiendu gallery and returns an id and public URL. If the seller only wanted to see it, stop there.
2. To use it in an ad, use the Meta media upload tool. If its contract accepts `upload_source=URL` and `media_type=IMAGE`, pass the public URL and use the returned `image_hash` (or other identifier) in the creative, following the current schema. A Tiendu gallery id is not a Meta id.
3. If the creative uses an AI-generated image and the contract offers `self_ai_disclosure`, declare it with `OPT_IN`. Check cropping, text, brand and consistency with the landing page.
4. To look at an existing ad's image, find its public URL through the Meta tools, import it with `images_create-from-url`, and inspect the returned gallery id with `images_inspect`. A Meta hash or id is not a gallery id. If Meta only gives a hash or an inaccessible URL, say you cannot inspect those pixels.

## Create and change

1. Pick or create the campaign and ad set that fit the goal. Use the exact tool names from the index, read their schemas and check each step's response. Do not invent fields or assume which level a budget belongs to.
2. Create the creative, then the ad. Keep the ad paused while you verify destination, copy, image, Pixel/dataset, budget and the state of campaign, ad set and ad. If the seller asked to publish, activate after review and approval; Meta may keep it in review.
3. To edit, read the current object, change only the needed fields and read it again. Changing status, budget or audience can affect spend and learning, so explain the scope before calling the tool.
4. Report what was created or changed, its real state, any pending Meta review and what to watch once it delivers. If a call fails, list which earlier steps were applied so a retry does not duplicate them.
