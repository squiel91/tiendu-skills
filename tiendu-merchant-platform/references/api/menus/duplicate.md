---
title: Duplicate a menu
description: Create a copy of an existing menu.
api:
  method: POST
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/menus/{menuId}/duplicate
---

Create a new menu from an existing one. The request has no body. The copy keeps the same items and receives a new title and handle.

The new title is the source title plus ` copia`. The new handle is derived from the source handle with a `-copia` suffix (and a numeric suffix if that handle is already taken).

> [!NOTE]
> `{menuId}` is the positive numeric ID of the menu to copy, returned by [List menus](list.md), not the handle.

## Request

```bash
curl https://tiendu.uy/api/v3/stores/my-store/menus/3/duplicate \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Response

HTTP 201 returns the new [menu object](object.md). The `Location` header contains its full URL.

The JSON is an example of a response.

```json
{
  "id": 4,
  "title": "Main menu copia",
  "handle": "main-menu-copia",
  "items": [
    {
      "id": 31,
      "position": 0,
      "label": "Shop",
      "url": "/collections/all",
      "resourceType": "collection",
      "resourceId": 5,
      "openInNewTab": false,
      "createdAt": "2026-09-20T12:10:00.000Z",
      "updatedAt": "2026-09-20T12:10:00.000Z"
    },
    {
      "id": 32,
      "position": 1,
      "label": "About",
      "url": "/pages/about",
      "resourceType": "page",
      "resourceId": 2,
      "openInNewTab": false,
      "createdAt": "2026-09-20T12:10:00.000Z",
      "updatedAt": "2026-09-20T12:10:00.000Z"
    }
  ],
  "createdAt": "2026-09-20T12:10:00.000Z",
  "updatedAt": "2026-09-20T12:10:00.000Z"
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 403 | The store has reached the menu or menu item safety limit. |
| 404 | Store or menu not found or unavailable to this key. |
| 412 | Store subscription does not permit access. |

See [Errors](../errors.md) for response examples and stable problem types.
