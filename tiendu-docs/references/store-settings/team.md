# Team (collaborators)

Collaborators are people who can open the Merchant Center of a store. They are not shoppers (those are under **Ventas → Clientes**).

Where: **Ajustes → Negocio → General → Equipo y permisos**.

## Rules

- Only an **owner** (*dueño*) can add collaborators, promote them to owner or remove them.
- An owner cannot be edited or removed from the panel. Owners can also manage collaborators and delete the store.
- A collaborator is added with name, surname and email. Name, surname and email are locked when editing; only **Es dueño** changes. A duplicate email is rejected ("Ya existe un colaborador con ese email").
- Plans call them "administradores"; the panel calls them **Colaboradores**.

## Interfaces

| Task | Tool |
|---|---|
| List | `collaborators_list` |
| Add (owners only) | `collaborators_create` (`isOwner` makes the person an owner) |
| Change owner flag | `collaborators_update` |
| Remove | `collaborators_delete` |

Tiendu support can also appear on the task board as **Soporte** without being a collaborator (see the tasks guide).
