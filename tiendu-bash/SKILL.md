---
name: tiendu-bash
description: Usá esta habilidad para scripts de operaciones por lotes, informes y cambios de tema mediante el entorno persistente bash de Manu y Git.
---

# Entorno de Manu

Usá herramientas directas para una operación simple. Usá `bash` cuando convenga paginar, transformar datos o ejecutar una lista de cambios secuenciales. Primero leé `/AGENTS.md`; `/script-references` contiene ejemplos que podés adaptar.

Antes de escribir un script, activá los nombres exactos con `manu_activate_tools` para consultar sus schemas en el próximo paso. Los contratos de `tools.*` son los de Manu, no los cuerpos REST v3. No pases storeId, userId ni credenciales: la identidad está fijada por el servidor.

Guardá el script en `/scripts` y ejecutá `js-exec -m /scripts/tarea.mjs`; también existe `js-exec -c 'código'`. Usá `await tools.products_list(input)` y `await tools['collections_add-products'](input)` para nombres con guion. Ejecutá una operación por vez; no uses Promise.all. `import fs from 'fs'` ofrece lecturas y escrituras locales. No hay npm, Node libre ni red general.

Paginar: respetá `data`, `pagination.totalPages`, page y size según el schema activo. Escribí listas de trabajo con IDs confirmados; no adivines productos ambiguos. Las actualizaciones de arrays reemplazan el valor completo: preservá los elementos que deban permanecer. Imprimí solo los IDs/campos útiles para la respuesta.

Una operación que necesita aprobación queda pendiente dentro del mismo script. Si el vendedor la rechaza, `catch` recibe un error con name `OperationNotApprovedError`, operation, approvalId y reason (`rejected` o `expired`). Podés continuar elementos independientes. Un stop termina la ejecución aunque el script capture errores.

Las operaciones confirmadas se registran fuera del script. Si hay un fallo, revisá sus recibos y continuá una lista explícita de pendientes; no repitas el comando entero ni escrituras inciertas. Un exitCode 0 o texto impreso no demuestra que todos los cambios tuvieron éxito.

El entorno pertenece a este vendedor y tienda. Todos sus archivos persisten, incluso /tmp y el historial .git; el límite total es 512 MB y 20.000 entradas. No hay restauración automática de archivos borrados. Las operaciones y la ejecución activa tienen límites: dividí lotes grandes.

Para temas, leé tiendu-theme. `/theme` es un clon Git: trabajá en una rama de vista previa, commit y push a origin. Push a live publica. Personalizar guarda commits; fetch trae esos cambios. No existe una herramienta de edición/publicación de temas ni una API alternativa. No expongas tokens. La inspección visual y el editor VS Code están pendientes.
