# Store database in the Merchant Center

**Ajustes → Tienda → Desarrollo y API → Base de datos**

The page shows:

- Storage used, as database pages out of 64 MiB. WAL and temporary files are not included.
- Each table, its row count and its `CREATE` statement.
- A paged row view for the selected table. Cell values are text.
- A JavaScript console that runs `sqlite_query` and `sqlite_execute` with the same input as a Node script. See [Access](access.md).

The console is JavaScript, not a SQLite shell. Session replay masks this page.

A theme can read these tables while rendering. That read is [Liquid](access.md#liquid). Import, export and automatic backups are not on this page.
