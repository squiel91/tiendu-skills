# Pages, blog and articles

## `page`

Page: `page` (`/paginas/{handle}`).

```ts
{
  id: number
  title: string | null
  handle: string
  url?: string
  publicUrl?: string
  coverImage: Image | null
  content: ContentBlock[]
  seo: { title: string | null; description: string | null }
  isListed: boolean
  isPublic: boolean
  templateSuffix: string | null
  createdAt: Date
  updatedAt: Date
}
```

`template_suffix` is also a top-level variable. A page can ignore `content` and render its own markup from an alternate template ([templates](../templates.md#custom-html-css-and-javascript-page)).

## `blog`

Page: `blog` (`/blog`). A synthetic object, not a stored entity.

```ts
{ title: 'Blog'; articles?: Article[]; articles_count?: number }
```

- `articles` is lazy and holds every listed article, newest first. It is not sliced by `{% paginate %}`: limit the loop yourself ([pagination](pagination.md#blog-articles)).
- It has no id, handle or URL; the blog index is `/blog`.

## `article` (alias `blogPost`)

Page: `article` (`/blog/{handle}`). Also the shape of items in `blog.articles` and of `article` settings.

```ts
{
  id: number
  title: string
  handle: string
  url?: string
  publicUrl?: string
  excerpt: string | null
  coverImage: Image | null
  manager: { name: string | null }       // author
  content: ContentBlock[]
  seo: { title: string | null; description: string | null }
  isListed: boolean
  templateSuffix: string | null
  createdAt: Date
  updatedAt: Date
}
```

## Rendering `content`

`content` is an ordered list of [content blocks](shared-shapes.md#contentblock). Render them by `type`:

```liquid
{% for block in page.content %}
  {% case block.type %}
    {% when 'heading' %}<h{{ block.level }}>{{ block.text | escape }}</h{{ block.level }}>
    {% when 'paragraph' %}<p>{{ block.text | escape }}</p>
    {% when 'image' %}<img src="{{ block.image.url | image_url: size: 'lg' | escape_attr }}" alt="{{ block.image.alt | escape_attr }}" data-size="{{ block.size }}" data-align="{{ block.align }}">
    {% when 'html' %}{{ block.code }}
  {% endcase %}
{% endfor %}
```

`html` blocks are merchant-authored markup and are output as written.
