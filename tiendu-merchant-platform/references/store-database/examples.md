# Blog comments

One `comments` table. The environment or the API creates it, a public Function accepts a comment, Liquid renders the approved rows, and MCP or the API moderates them. The statement rules are in [Store database](overview.md). The callers are in [Access](access.md).

`post_id` is `article.handle` from the blog post. New comments stay hidden (`approved = 0`) until someone approves them. The public query never selects an email or other private column.

## Create the table

From a Node script in the environment, or the same statements through [execute](../api/database/execute.md):

```js
await tools.sqlite_execute({ statements: [
  { sql: `CREATE TABLE IF NOT EXISTS comments (
    id INTEGER PRIMARY KEY,
    post_id INTEGER NOT NULL,
    author TEXT NOT NULL,
    body TEXT NOT NULL,
    approved INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL
  ) STRICT` },
  { sql: 'CREATE INDEX IF NOT EXISTS comments_post_id ON comments(post_id, approved)' }
] })
```

## Accept a comment

A public Function at `https://stores.tiendu.uy/{storeHandle}/functions/comments`. Request `sqlite_execute` and have the merchant grant it. The SQL stays in the file. The body is only author and text.

```js
class InputError extends Error {}

function requiredString(value, field, max) {
  if (typeof value !== 'string') throw new InputError(`${field} is required`)
  const text = value.trim()
  if (!text || text.length > max) throw new InputError(`${field} is invalid`)
  return text
}

export default {
  async fetch(request) {
    if (request.method !== 'POST') {
      return new Response(null, { status: 405, headers: { Allow: 'POST' } })
    }
    let body
    try {
      body = await request.json()
    } catch {
      return Response.json({ error: 'Invalid JSON' }, { status: 400 })
    }
    let author, text, postId
    try {
      author = requiredString(body.author, 'author', 80)
      text = requiredString(body.body, 'body', 2000)
      postId = Number(body.postId)
      if (!Number.isInteger(postId) || postId <= 0) throw new InputError('postId is invalid')
    } catch (error) {
      if (error instanceof InputError) {
        return Response.json({ error: error.message }, { status: 400 })
      }
      throw error
    }
    try {
      const saved = await tools.sqlite_execute({ statements: [
        {
          sql: `INSERT INTO comments (post_id, author, body, approved, created_at)
                VALUES (?, ?, ?, 0, ?)`,
          params: [postId, author, text, new Date().toISOString()]
        }
      ] })
      return Response.json({ id: saved.results[0].lastInsertRowid }, { status: 201 })
    } catch (error) {
      if (error.outcome === 'unknown') {
        return Response.json({ error: 'Could not confirm the comment' }, { status: 504 })
      }
      console.error(error)
      return Response.json({ error: 'Could not save the comment' }, { status: 500 })
    }
  }
}
```

If `outcome` is `unknown`, do not insert again. Look the row up first. A `constraint` or `invalid-sql` error has already rolled back.

The storefront form posts JSON to that URL. It does not talk to SQLite.

```js
await tiendu.functions.fetch('comments', {
  method: 'POST',
  headers: { 'content-type': 'application/json' },
  body: JSON.stringify({ postId: articleId, author, body })
})
```

## Show approved comments

On the article template, `article.handle` is the post. The read is the Liquid tag in [Access](access.md#liquid). Select `author`, `body` and `created_at` only, and escape them.

## Moderate

Approve one comment from MCP or `sqlite_execute`. This is a write, not something the theme or the public Function does.

```js
await tools.sqlite_execute({ statements: [
  { sql: 'UPDATE comments SET approved = 1 WHERE id = ?', params: [7] }
] })
```

List the queue:

```js
const pending = await tools.sqlite_query({
  sql: `SELECT id, post_id, author, body, created_at
        FROM comments WHERE approved = 0 ORDER BY created_at`,
  params: []
})
```

The same `SELECT` is the body of `POST /database/query`.

## Other tables

A contact form uses the same Function shape with no `post_id`: `author`, `email`, `message`, `created_at`. Keep `email` off any Liquid `SELECT`.

A cache uses a key and an expiry, written by a Function or a script and read by Liquid or the next call:

```sql
CREATE TABLE IF NOT EXISTS integration_cache (
  key TEXT PRIMARY KEY,
  payload TEXT NOT NULL,
  expires_at TEXT NOT NULL
) STRICT
```

`payload` is `JSON.stringify(value)`. Read it with `json_extract`. Delete expired rows in an `sqlite_execute` before inserting the replacement. A waiting list is the comments table with a product id instead of `post_id`.
