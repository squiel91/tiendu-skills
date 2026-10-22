# Tasks board (Tareas)

The store home (**Inicio**, `/admin/tiendas/{storeHandle}`) is a Kanban board shared by the store team and Manu. Sellers say *tareas*, *tablero*, *pendientes*.

## Columns

| `status` | Label |
|---|---|
| `proposed` | Propuestas: ideas not accepted yet |
| `todo` | Para hacer |
| `doing` | Haciendo |
| `done` | Terminadas |

Columns are fixed. A task has a title, a description (plain text), an optional assignee (a collaborator, or Manu), labels, an optional due date (`dueOn`, `YYYY-MM-DD`), a checklist, attachments and comments.

## Automatic tasks

Some tasks mirror an order and update themselves (`source` is set): one card per order that needs the seller (confirm, mark paid, send, deliver), moved by the order's status.

A new store also starts with a few getting-started tasks (label PRIMEROS PASOS) in Para hacer. They are ordinary tasks.

Their title, description, labels and attachments cannot change, and their column cannot be changed by hand (`statusLocked`); only reordering inside the column, assignee, due date, checklist, comments, archive and delete work.

## Checklist

A task can have one checklist: ordered items that are checked off as the work advances (checked items show struck through, and the card shows progress such as `2/5`). `tasks_get` returns it as `checklist` (`id`, `text`, `checked`). `tasks_checklist_add` adds one or more items, `tasks_checklist_update` checks, unchecks, renames or moves one (`index`), and `tasks_checklist_delete` removes one. Automatic tasks can have a checklist too.

## Archiving

Tasks are archived, not deleted: `tasks_archive` takes a task off the board but keeps its comments and `tasks_unarchive` restores it. `tasks_delete` works only on archived tasks. If the work is finished, move it to `done` instead of archiving.

## Labels

Labels are store-wide and unique by name. Colors are a hue (green, yellow, orange, red, purple, blue, sky, lime, pink, gray) with an optional `-dark` or `-light` suffix. New stores start with URGENTE, IDEA, MARKETING, DISEÑO, CATÁLOGO, ENVÍOS, CLIENTES, BLOQUEADA and PRIMEROS PASOS.

## Comments and Manu

- Mention a collaborator with `<#user:ID>` and Manu with `<#manu>`. Reference a resource with `<#product:ID>` (also collections, pages, menus, articles, tasks).
- Mentioning `<#manu>` or assigning the task to Manu makes Manu work on it; the mentioning comment shows 👀 while Manu works on it; Manu reads the task, works, and posts one brief result comment.
- Tiendu Support appears as **Soporte** on every board and can be mentioned to escalate.
- Reactions use a fixed set of emojis.

## Interfaces

| Task | Tool |
|---|---|
| Board | `tasks_list`, `tasks_get`, `tasks_create`, `tasks_update`, `tasks_move`, `tasks_archive`, `tasks_unarchive`, `tasks_archived_list`, `tasks_delete` |
| Labels | `tasks_labels_list`, `_create`, `_update`, `_delete` |
| Checklist | `tasks_checklist_add`, `_update`, `_delete` |
| Comments | `tasks_comments_list`, `_create`, `_react`, `_delete` |

Tasks are not part of the REST v3 API.

## In the Merchant Center

**Inicio** (`/admin/tiendas/{storeHandle}`), tab **Tareas**. Above the board there is a greeting and Manu's message box; the other tab is **Desempeño**.

- Drag cards between columns. Locked (automatic) cards show ⚡ and snap back with a notice if dropped in another column.
- Filters (kept in the URL): one person (a collaborator, Manu, or **Sin asignar**) and one or more labels.
- **Archivadas** swaps the board for the archived list, where tasks can be restored or deleted.
- Open a task with `?task=ID` to see its description, checklist, comments and attachments.
- **Checklist**: add items with **Agregar un checklist** (pasting a list adds one item per line). Checking an item strikes it through; click its text to edit it. A progress bar shows how much is done, **Ocultar marcados** hides checked items, and cards show the count (`2/5`, green when complete).
- A blue dot marks a card that is new to you (created by someone else) or has comments you have not seen; the comment count turns blue. Opening the card clears it.
- You get an in-app notification when someone mentions you, and when someone comments on a task you are assigned to or have commented on.
