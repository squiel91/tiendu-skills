# Tickets de soporte

## Qué es

Los tickets reúnen consultas, problemas y pedidos de funciones para el equipo de
Tiendu. Cada ticket tiene un asunto y una conversación; actualmente no tiene un
campo de categoría. Para distinguir un error de una idea, aclaralo en el asunto
o en el mensaje.

## Dónde está

Menú: **Ajustes** → pestaña **Tickets** (antes de **Suscripción**).

URL de la bandeja:

```text
/admin/tiendas/{storeHandle}/ajustes/tickets
```

Para abrir directamente un ticket, agregá su número como `ticketId`:

```text
/admin/tiendas/{storeHandle}/ajustes/tickets?ticketId={ticketId}
```

Por ejemplo: `/admin/tiendas/tienda-lucas/ajustes/tickets?ticketId=123` abre el
ticket **#123** de esa tienda. Las notificaciones de tickets también llevan a
este enlace. El link requiere acceso al Merchant Center de esa tienda.

Al seleccionar un ticket desde la bandeja, la dirección del navegador no se
actualiza automáticamente. Para compartir o guardar un enlace directo, usá la
versión con `?ticketId={ticketId}`.

## Crear y responder

- **Nuevo ticket** pide **Asunto** y **¿En qué podemos ayudarte?**. El equipo se
  compromete a responder como máximo el próximo día hábil.
- La conversación muestra los mensajes y cambios de estado.
- **Tu respuesta** permite agregar un mensaje. **Cerrar ticket** pide confirmar
  antes de cerrarlo.
- Los estados visibles son **Abierto**, **En progreso**, **Esperando respuesta
  del vendedor**, **Resuelto** y **Cerrado**.

Manu también puede ayudar a crear o responder tickets. Solo publica una
respuesta cuando el vendedor se lo pide.
