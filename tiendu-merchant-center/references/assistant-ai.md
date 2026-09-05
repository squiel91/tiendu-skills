# Asistente / IA (Manu)

## Qué es

**Manu** es el asistente de IA del Merchant Center: ayuda a gestionar la tienda
por chat (productos, pedidos, contenido, “cómo hago X”, etc.). Las
**Reglas del asistente** personalizan su comportamiento en el chat web del
panel y también en WhatsApp (mismo Manu, otro canal).

No hay una pantalla aparte de “créditos de IA” ni de facturación del asistente
en el Merchant Center: el uso se contabiliza en backend; en el chat del panel
no se muestra saldo ni tope.

## Dónde está

### Chat Manu (“¿Te doy una mano?”)

- Botón fijo a la derecha del panel (rotado): **¿Te doy una mano?**
- Abre el drawer **Asistente Manu** — subtítulo “Especialista IA en ventas
  online”.
- Placeholder: **Escribí tu mensaje…**; adjuntar imágenes (clip); tilde
  **Enviar al presionar Enter** (desktop).
- Cerrar: botón **Cerrar chat**.

Desde varias listas (cupones, categorías, etc.) la sección de ayuda dice
“preguntándole a Manu” y al tocar una pregunta abre el mismo chat con ese
texto.

No depende de un ítem del menú lateral.

### Reglas del asistente

1. **Ajustes** → **General**  
   URL: `/admin/tiendas/{storeHandle}/ajustes/general`
2. Sección colapsada **Reglas del asistente**  
   Resumen UI: “Definí reglas para personalizar cómo se comporta tu asistente
   AI en la web y WhatsApp.”

| Acción / campo | Notas |
|----------------|--------|
| **Regla** (textarea) | Texto de la instrucción. Placeholder ej.: “nunca uses emojis…”. |
| **Agregar** | Crea la regla. |
| **Guardar** / **Borrar** | Por cada regla existente. |

Límites visibles en UI:

- Hasta **6** reglas por tienda.
- Hasta **2024** caracteres por regla.

### WhatsApp (menciones en el panel)

- Las reglas aplican explícitamente a **web y WhatsApp**.
- En **Ajustes → General → Contacto** el campo **Número de WhatsApp** es el
  contacto de **la tienda** (lo que ve el comprador / links), **no** un
  interruptor del asistente.
- No hay pestaña “Asistente WhatsApp” aparte en Ajustes.

### Onboarding / checklist

En **Resúmen** (home del admin) puede haber un checklist de activación de la
tienda (productos, categorías, entregas, etc.). Eso **no** es un chat de
onboarding con Manu; es una lista de tareas del resumen.

Los planes (landing / pricing) mencionan “Asistente de IA básico / avanzado /
proactivo”; eso es marketing de plan, no pantallas distintas dentro del
Merchant Center.

## Ejemplo

1. Abrí **¿Te doy una mano?** y preguntá: `¿Cómo creo un cupón de 15%?`
2. Para tono fijo: **Ajustes → General → Reglas del asistente** →
   `Respondé siempre en español rioplatense, sin emojis` → **Agregar**

## Tips / no confundir

- **Manu (admin)** ≠ chatbot de atención al comprador en la tienda pública (comprador).
- **Reglas del asistente** ≠ **Redirecciones** ni **Notificaciones** (otras
  secciones de General).
- **Número de WhatsApp** en Contacto ≠ configuración del canal del asistente.
- Campañas / Meta / “WhatsApp” en Integraciones son marketing o catálogo, no
  el chat de Manu.
