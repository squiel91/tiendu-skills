# Colaboradores

## Qué es

Los **colaboradores** son personas con acceso al Merchant Center de esa tienda
(administradores). Un **dueño** puede invitar, promover a dueño o remover a
otros; los dueños no se pueden remover desde esta pantalla.

## Dónde está

Menú: **Ajustes** → pestaña **Colaboradores**

URL: `/admin/tiendas/{storeHandle}/ajustes/colaboradores`

(Las pestañas de Ajustes son: General, Dominios, **Colaboradores**,
Integraciones, Entregas, Metadatos, Tema.)

## Lista y acciones

Cada fila muestra nombre, email y, si corresponde, badge **Dueño**.

- **Agregar colaborador**: solo si el usuario actual es dueño.
- **Editar**: abre un panel lateral. Deshabilitado para filas que ya son
  **Dueño**.

## Campos (panel Agregar / Editar)

| Campo | Notas |
|-------|--------|
| **Nombre** | Obligatorio al crear. Bloqueado al editar. |
| **Apellido** | Obligatorio al crear. Bloqueado al editar. |
| **Email** | Obligatorio, formato válido. Bloqueado al editar. |
| **Es dueño** | Tilde. Solo dueños pueden cambiarlo. |

Al marcar **Es dueño** (al crear o al promover) aparece el aviso:

> Como dueño, el colaborador no podrá ser removido, podrá gestionar
> colaboradores y borrar la tienda.

Acciones del panel:

- **Guardar cambios**
- **Remover colaborador** (solo en edición, si no es dueño; pide confirmación)

## Reglas

- Solo un **dueño** ve el botón de agregar y puede guardar / remover.
- No se puede editar ni remover a alguien que ya es dueño desde esta UI.
- Email duplicado: “Ya existe un colaborador con ese email.”
- Nombre / apellido / email vacíos o email inválido muestran error en el campo.

## Ejemplo

1. **Ajustes** → **Colaboradores** → **Agregar colaborador**
2. Nombre, apellido y email del equipo
3. Dejá **Es dueño** sin marcar (colaborador normal) → **Guardar cambios**

## Tips / no confundir

- No es un **cliente** de la tienda (eso está en **Ventas → Clientes**).
- No es el **Número de WhatsApp** de contacto de la tienda.
- Los planes comerciales hablan de “administradores”; en el panel la sección se
  llama **Colaboradores**.
