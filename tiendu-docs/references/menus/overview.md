# Menus

A **menu** (*menú*) is a navigation list the theme shows, such as the main menu or the footer. A menu has a unique `handle` and a list of `items`; themes read it by handle (`menus['main-menu']`).

## Items

Each item has:

- `label`: the text shown (themes render `link.label`).
- `url`: where it goes.
- Optional `resourceType` (`product`, `collection`, `page` or `article`) and `resourceId`, which link the item to a store resource.
- Optional `openInNewTab`.

## Rules and edge cases

- `menus_update` with `items` **replaces all items**; send the complete list.
- A page or blog post is not in the navigation until a menu item points to it.
- `menus_duplicate` copies a menu with its items.
- Deleting a menu deletes its items. A theme that reads a deleted handle shows no menu.

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| List, get | `menus_list`, `menus_get` | `GET /menus`, `GET /menus/{menuId}` |
| Create, update, delete | `menus_create`, `menus_update`, `menus_delete` | `POST /menus`, `PATCH /menus/{menuId}`, `DELETE /menus/{menuId}` |
| Duplicate | `menus_duplicate` | `POST /menus/{menuId}/duplicate` |

Where to find them: **Contenido → Menús** (`/admin/tiendas/{storeHandle}/menus`).
