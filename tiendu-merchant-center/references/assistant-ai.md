# Asistente e IA (Manu)

## Qué es

En Tiendu hay **asistencia con IA** en dos contextos distintos. Manu es el
nombre del asistente.

1. **Manu en el Merchant Center** — te ayuda a usar el panel (preguntas sobre
   productos, cupones, etc.).
2. **Asistente de la tienda (web / WhatsApp)** — atiende o asesora a compradores
   en la tienda. Su tono y límites se personalizan con **Reglas del asistente**.

Este archivo junta todo lo relacionado a IA que el vendedor toca en el panel.

## Manu en el Merchant Center

### Dónde abrirlo

- Botón lateral **¿Te doy una mano?** (fijo a la derecha en el admin de la tienda).
- Abre el chat **Asistente Manu**.
- En varias pantallas, abajo: *“Entendé sobre … preguntándole a Manu”* con
  preguntas sugeridas que abren el mismo chat.

### Para qué sirve

Explicar el panel, sugerir pasos y responder dudas de configuración de **esa**
tienda. No reemplaza las secciones del menú: si hay que crear un cupón, igual
se hace en **Cupones**.

## Reglas del asistente (tienda / WhatsApp)

### Dónde está

**Ajustes → General → Reglas del asistente**
(`/admin/tiendas/{storeHandle}/ajustes/general`, sección colapsable).

Texto de ayuda en pantalla: personalizan cómo se comporta el asistente AI en
**la web y WhatsApp**.

### Límites

| Límite | Valor |
|--------|--------|
| Cantidad de reglas | Hasta **6** por tienda |
| Largo de cada regla | Hasta **2024** caracteres |

### Cómo se usan

1. Escribí una **Regla** (ej. “nunca uses emojis en tus respuestas”).
2. **Agregar**.
3. Para cambiar una existente: editá el texto → **Guardar**, o borrála.

## Qué no mezclar

| Cosa | No es |
|------|--------|
| **Manu en el panel** | El chat de ayuda del Merchant Center. |
| **Reglas del asistente** | Instrucciones para el asistente que habla con **compradores** (web/WhatsApp). |
| **Número de WhatsApp** (Ajustes → contacto) | El teléfono de la tienda; no es lo mismo que las reglas, aunque el asistente pueda usarse por WhatsApp. |

## Ejemplo

Querés que el asistente de la tienda no invente precios:

1. **Ajustes → General** → abrí **Reglas del asistente**
2. Regla: `Si no sabés el precio exacto, pedí que miren el producto en la tienda`
3. **Agregar**

Para una duda de cómo crear un cupón en el panel: abrí **¿Te doy una mano?** y
preguntale a Manu, o seguí `coupons.md`.

## Tips

- Pocas reglas claras suelen funcionar mejor que un párrafo largo.
- Si Manu del panel no alcanza, usá la documentación del skill / links de ayuda
  de cada pantalla.
