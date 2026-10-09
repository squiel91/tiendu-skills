# Tasks board (Tareas)

The store home (**Inicio**, `/admin/tiendas/{storeHandle}`) is a Kanban board shared by the store team and Manu. Sellers say *tareas*, *tablero*, *pendientes*.

## Columns

| `status` | Label |
|---|---|
| `proposed` | Propuestas: ideas not accepted yet |
| `todo` | Para hacer |
| `doing` | Haciendo |
| `done` | Terminadas |

Columns are fixed. A task has a title, a description (plain text), an optional assignee (a collaborator, or Manu), labels, an optional due date (`dueOn`, `YYYY-MM-DD`), attachments and comments.

## Automatic tasks

Some tasks mirror something else and update themselves (`source` is set):

- **Getting-started steps**: one card per unfinished activation step, in Para hacer.
- **Orders**: one card per order that needs the seller (confirm, mark paid, send, deliver), moved by the order's status.

Their title, description, labels and attachments cannot change, and their column cannot be changed by hand (`statusLocked`); only reordering inside the column, assignee, due date, comments, archive and delete work.

## Archiving

Tasks are archived, not deleted: `tasks_archive` takes a task off the board but keeps its comments and `tasks_unarchive` restores it. `tasks_delete` works only on archived tasks. If the work is finished, move it to `done` instead of archiving.

## Labels

Labels are store-wide and unique by name. Colors are a hue (green, yellow, orange, red, purple, blue, sky, lime, pink, gray) with an optional `-dark` or `-light` suffix. New stores start with URGENTE, IDEA, MARKETING, DISEÑO, CATÁLOGO, ENVÍOS, CLIENTES, BLOQUEADA and PRIMEROS PASOS.

## Comments and Manu

- Mention a collaborator with `<@user:ID>` and Manu with `<@manu>`. Reference a resource with `<#products:ID>` (also collections, pages, menus, articles).
- Mentioning `<@manu>` or assigning the task to Manu makes Manu work on it; Manu reacts 👍 to the mentioning comment, reads the task, works, and posts one brief result comment.
- Tiendu Support appears as **Soporte** on every board and can be mentioned to escalate.
- Reactions use a fixed set of emojis.

## Interfaces

| Task | Tool |
|---|---|
| Board | `tasks_list`, `tasks_get`, `tasks_create`, `tasks_update`, `tasks_move`, `tasks_archive`, `tasks_unarchive`, `tasks_archived_list`, `tasks_delete` |
| Labels | `tasks_labels_list`, `_create`, `_update`, `_delete` |
| Comments | `tasks_comments_list`, `_create`, `_react`, `_delete` |

Tasks are not part of the REST v3 API. Where to find them: [Merchant Center](panel.md).
