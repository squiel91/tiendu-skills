---
name: tiendu-bash
description: Usá esta habilidad para scripts de operaciones por lotes, informes y cambios de tema mediante el entorno persistente bash de Manu y Git.
---

# Entorno de Manu

Usá herramientas directas para una operación simple. Usá `bash` cuando convenga paginar, transformar datos o ejecutar una lista de cambios secuenciales. Primero leé `/AGENTS.md`; `/script-references` contiene ejemplos que podés adaptar.

Antes de escribir un script, activá los nombres exactos con `manu_activate_tools` para consultar sus schemas en el próximo paso. Los contratos de `tools.*` son los de Manu, no los cuerpos REST v3. No pases storeId, userId ni credenciales: la identidad está fijada por el servidor.

Guardá el script como módulo `.mjs` en `/scripts` y ejecutá `node /scripts/tarea.mjs`; para código breve usá `node --input-type=module -e 'código'`. `tools` y `OperationNotApprovedError` ya están disponibles automáticamente en Node, sin imports ni un ejecutor especial. Usá `await tools.products_list(input)` y `await tools['collections_add-products'](input)` para nombres con guion. Ejecutá una operación por vez; no uses Promise.all. `import fs from 'fs'` ofrece lecturas y escrituras locales. Bash, Git, Node y npm son nativos dentro de un contenedor aislado. El directorio actual es /workspace; /theme, /scripts, /reports y /script-references apuntan a sus carpetas. No hay red general: Git usa el relay del servidor y tools.* usa el puente autenticado. No podés descargar paquetes de Internet en esta versión.

Paginar: products_list recibe `page` y `size` directamente y devuelve `data` y `pagination: {total, page, size}`; no existe totalPages. Terminá si `data.length === 0` o `pagination.page * pagination.size >= pagination.total`. Consultá el schema activo para otras operaciones; no asumas que todas tienen el mismo contrato. Escribí listas de trabajo con IDs confirmados; no adivines productos ambiguos. Las actualizaciones de arrays reemplazan el valor completo: preservá los elementos que deban permanecer. Imprimí solo los IDs/campos útiles para la respuesta.

Una operación que necesita aprobación queda pendiente dentro del mismo script. Si el vendedor la rechaza, `catch` recibe un error con name `OperationNotApprovedError`, operation, approvalId y reason (`rejected` o `expired`). Podés continuar elementos independientes. Un stop termina la ejecución aunque el script capture errores.

Las operaciones confirmadas se registran fuera del script. Si hay un fallo, revisá sus recibos y continuá una lista explícita de pendientes; no repitas el comando entero ni escrituras inciertas. Un exitCode 0 o texto impreso no demuestra que todos los cambios tuvieron éxito.

El entorno pertenece a la tienda y es compartido por todos sus vendedores, sus Manu y el editor. Todos usan el mismo clon /theme: comparten archivos, rama, índice y cambios sin commit. Inspeccioná git status antes de modificar o cambiar de rama; preservá cambios ajenos. No hay carpetas de trabajo ni worktrees independientes en esta versión. Todos los archivos persisten, incluso /tmp, dependencias, datos del editor y el historial .git; el límite conjunto es 1 GiB por tienda y hasta 20.000 entradas. Un error ENOSPC significa que la tienda debe liberar espacio antes de reintentar. No hay restauración automática de archivos borrados. Las operaciones y la ejecución activa tienen límites: dividí lotes grandes.

Para temas, leé tiendu-theme. `/theme` es un clon Git: trabajá en una rama de vista previa, commit y push a origin. Push a live publica. Personalizar guarda commits; fetch trae esos cambios. No existe una herramienta de edición/publicación de temas ni una API alternativa. No expongas tokens. El editor VS Code usa el mismo entorno persistente de la tienda; sus operaciones tienen la identidad del vendedor que lo abrió. La inspección visual está pendiente.
