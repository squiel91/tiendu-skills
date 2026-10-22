# Menus

A **menu** (*menú*) is a navigation list the theme shows, such as the main menu or the footer. A menu has a unique `handle` and a list of `items`; storefronts request it by handle through the Store API.

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

| Task | Tool | REST API |
|---|---|---|
| List, get | `menus_list`, `menus_get` | `GET /menus`, `GET /menus/{menuId}` |
| Create, update, delete | `menus_create`, `menus_update`, `menus_delete` | `POST /menus`, `PATCH /menus/{menuId}`, `DELETE /menus/{menuId}` |
| Duplicate | `menus_duplicate` | `POST /menus/{menuId}/duplicate` |

Where to find them: **Contenido → Menús** (`/admin/tiendas/{storeHandle}/menus`).

## In the Merchant Center

Menu **Contenido → Menús** (`/admin/tiendas/{storeHandle}/menus`). **Agregar** opens `/menus/agregar`; an existing menu opens at `/menus/{menuId}`.

The editor has the menu name, its identifier (the `handle` themes read) and **Elementos del menú**, with **Agregar elemento del menú**. Each item has a label and a destination: a store resource (product, collection, page or blog post) or a custom URL. Items are ordered as they should appear in the storefront. **Borrar menú** is in the menu actions.

Menus are flat: items cannot be nested. An item stores the URL it had when saved, so renaming a resource's handle does not update the menu item; edit the item.

## API reference

[Menus REST API](../api/menus/overview.md).
