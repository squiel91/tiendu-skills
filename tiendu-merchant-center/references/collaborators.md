# Colaboradores

## Qué es

Los **colaboradores** son personas con acceso al **Merchant Center** de esa
tienda. Un colaborador marcado como **Dueño** tiene permisos máximos.

## Dónde está

**Ajustes → Colaboradores** → `/admin/tiendas/{storeHandle}/ajustes/colaboradores`

## Quién puede gestionar

Solo un **dueño** ve **Agregar colaborador** y puede guardar / remover (salvo
otros dueños).

## Agregar colaborador (drawer)

| Campo | Notas |
|-------|--------|
| **Nombre** / **Apellido** | Obligatorios. |
| **Email** | Obligatorio y válido. Con ese mail entra al panel. |
| **Es dueño** | Si lo tildás, el colaborador no se podrá remover después, podrá gestionar colaboradores y podrá borrar la tienda. |

## Editar / remover

- Los que ya son **Dueño** no se editan ni se remueven desde la lista.
- En edición de un no-dueño: podés pasar a **Es dueño** o **Remover colaborador**.

## Ejemplo

Invitar a alguien del equipo:

1. **Ajustes → Colaboradores** → **Agregar colaborador**
2. Nombre, apellido, email
3. Dejá **Es dueño** destildado si solo necesita operar el día a día
4. **Guardar cambios**

## Tips

- No confundir colaboradores (acceso al admin) con **Clientes** (compradores).
- Cuidado con **Es dueño**: es irreversible desde esta pantalla para ese usuario.
