---
title: Get a menu
description: Retrieve one menu by its numeric ID.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/menus/{menuId}
---

Return one menu from the store.

> [!NOTE]
> `{menuId}` is the positive numeric ID returned by [List menus](list.md), not the handle.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/menus/3 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 200 returns the [menu object](object.md).

The JSON is an example of a response.

```json
{
  "id": 3,
  "title": "Main menu",
  "handle": "main-menu",
  "items": [
    {
      "id": 11,
      "position": 0,
      "label": "Shop",
      "url": "/collections/all",
      "resourceType": "collection",
      "resourceId": 5,
      "openInNewTab": false,
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    },
    {
      "id": 12,
      "position": 1,
      "label": "About",
      "url": "/pages/about",
      "resourceType": "page",
      "resourceId": 2,
      "openInNewTab": false,
      "createdAt": "2026-09-20T12:00:00.000Z",
      "updatedAt": "2026-09-20T12:00:00.000Z"
    }
  ],
  "createdAt": "2026-09-20T12:00:00.000Z",
  "updatedAt": "2026-09-20T12:00:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store or menu not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
