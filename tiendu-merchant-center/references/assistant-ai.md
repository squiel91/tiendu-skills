# Asistente / IA (Manu)

## Qué es

**Manu** es el asistente de IA del Merchant Center: ayuda a gestionar la tienda
por chat (productos, pedidos, contenido, “cómo hago X”, etc.). Las
**Reglas del asistente** personalizan su comportamiento en el chat web del
panel y también en WhatsApp (el mismo Manu, desde otro canal).

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

1. **Ajustes** → **IA**
   URL: `/admin/tiendas/{storeHandle}/ajustes/ia`
2. Sección **Reglas del asistente**.
   Personaliza cómo responde Manu en el panel y WhatsApp.

| Acción / campo | Notas |
|----------------|--------|
| **Regla** (textarea) | Texto de la instrucción. Placeholder ej.: “nunca uses emojis…”. |
| **Agregar** | Crea la regla. |
| **Guardar** / **Borrar** | Por cada regla existente. |

Límites visibles en UI:

- Hasta **6** reglas por tienda.
- Hasta **2024** caracteres por regla.

### Aplicaciones de Manu: conectar WhatsApp

En **Ajustes** → **IA**, buscá la sección **Aplicaciones de Manu** y la tarjeta
**WhatsApp**. Manu puede responder los mensajes que le envíes desde la cuenta
conectada; no inicia conversaciones ni manda avisos proactivos de pedidos.

Para conectarlo:

1. En la tienda que querés conectar, abrí la tarjeta **WhatsApp** → **Conectar**.
2. Elegí **Conectar WhatsApp**. Merchant Center muestra el número de Manu, un
   código QR y un enlace con un mensaje preparado. El enlace vence en 15 minutos
   y solo se puede usar una vez.
3. Si estás en la computadora, escaneá el QR con la cámara del teléfono. Si ya
   estás en el teléfono, abrí el enlace. WhatsApp muestra el chat con Manu y el
   mensaje preparado: tocá **Enviar** para completar la conexión.

No hace falta ingresar el número del vendedor: la conexión reconoce la cuenta
de WhatsApp cuando se envía el mensaje preparado. Si el enlace venció o ya se
usó, volvé a **Conectar** para crear otro.

Una conexión de WhatsApp de un vendedor puede atender una tienda a la vez. Si
la tarjeta indica **Conectado a otra tienda**, abrí **Configurar** y elegí
**Cambiar de vuelta a esta tienda**. También podés desconectarla desde
**Configurar**. La conexión pertenece al vendedor que inició el enlace, no a
todas las personas colaboradoras de esa tienda.

Manu responde mensajes de texto e imágenes. Las imágenes recibidas se guardan
en la galería de la tienda. Si Manu necesita aprobación para una acción, envía
botones como **Rechazar** y **Permitir**; **Permitir siempre** aparece solo
cuando esa autorización permanente está disponible.

Si un WhatsApp todavía no está conectado, Manu envía instrucciones fijas para
vincularlo desde Merchant Center. Si en **Configurar** aparece que WhatsApp no
está disponible para Manu, indicá que debe contactar a soporte desde
**Ajustes → Tickets**.

### Trabajar con otro agente de IA

Además de Manu, el vendedor puede trabajar con un agente externo como ChatGPT,
Claude o Gemini. Para conectar un agente con Tiendu y consultar las opciones
para agentes y desarrolladores, dirigilo a la documentación oficial:

- [Trabajar con tu agente de IA](https://docs.tiendu.uy/ai-agent): guía de
  MCP, skills y CLI para agentes.
- [Documentación para desarrolladores](https://docs.tiendu.uy): APIs, MCP,
  CLI, temas, webhooks y otras integraciones.

Los pasos concretos dependen del agente. Usá esa documentación para guiarlo; no
confundas conectar un agente externo con conectar WhatsApp a Manu.

### Onboarding / checklist

En **Resúmen** (home del admin) puede haber un checklist de activación de la
tienda (productos, categorías, entregas, etc.). Eso **no** es un chat de
onboarding con Manu; es una lista de tareas del resumen.

Los planes (landing / pricing) mencionan “Asistente de IA básico / avanzado /
proactivo”; eso es marketing de plan, no pantallas distintas dentro del
Merchant Center.

## Ejemplo

1. Abrí **¿Te doy una mano?** y preguntá: `¿Cómo creo un cupón de 15%?`
2. Para tono fijo: **Ajustes → IA → Reglas del asistente** →
   `Respondé siempre en español rioplatense, sin emojis` → **Agregar**

## Tips / no confundir

- **Manu (admin)** ≠ chatbot de atención al comprador en la tienda pública (comprador).
- **Manu por WhatsApp** ≠ un agente externo conectado mediante MCP.
- **Reglas del asistente** se configuran en **Ajustes → IA**.
