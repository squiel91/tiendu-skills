---
title: Update a menu
description: Change selected menu fields.
api:
  method: PATCH
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/menus/{menuId}
---

Send any nonempty subset of the [create fields](create.md#request-body) directly in the JSON body. Omitted fields remain unchanged. `id` and timestamps cannot be edited.

> [!WARNING]
> A supplied `items` array replaces the whole menu item list. Existing item ids are discarded and new ids are assigned. Omit `items` to leave the current links unchanged.

> [!NOTE]
> `{menuId}` is the positive numeric ID returned by [List menus](list.md), not the handle.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/menus/3 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Primary navigation",
    "items": [
      {
        "label": "Shop",
        "url": "/collections/all",
        "resourceType": "collection",
        "resourceId": 5
      },
      {
        "label": "Contact",
        "url": "/pages/contact",
        "resourceType": "page",
        "resourceId": 8,
        "openInNewTab": true
      }
    ]
  }'
```

## Response

HTTP 200 returns the updated [menu object](object.md).

The JSON is an example of a response.

```json
{
  "id": 3,
  "title": "Primary navigation",
  "handle": "main-menu",
  "items": [
    {
      "id": 21,
      "position": 0,
      "label": "Shop",
      "url": "/collections/all",
      "resourceType": "collection",
      "resourceId": 5,
      "openInNewTab": false,
      "createdAt": "2026-09-20T12:05:00.000Z",
      "updatedAt": "2026-09-20T12:05:00.000Z"
    },
    {
      "id": 22,
      "position": 1,
      "label": "Contact",
      "url": "/pages/contact",
      "resourceType": "page",
      "resourceId": 8,
      "openInNewTab": true,
      "createdAt": "2026-09-20T12:05:00.000Z",
      "updatedAt": "2026-09-20T12:05:00.000Z"
    }
  ],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:05:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 400 | Invalid JSON body. |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the menu item safety limit. |
| 404 | Store or menu not found or unavailable to this key. |
| 409 | Menu handle already exists in this store. |
| 412 | Store subscription does not permit access. |
| 415 | `Content-Type` is not `application/json`. |
| 422 | Invalid menu fields, or empty body. |

See [Errors](../errors.md) for response examples and stable problem types.
