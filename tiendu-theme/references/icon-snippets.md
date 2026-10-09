# Icon snippets

Icons are snippets named `icon-<name>.liquid`, generated from an icon library with `@ckreidl/sis`. Reuse an existing icon before adding one, and match the visual weight and style of the icons already in the theme.

```bash
npx @ckreidl/sis add lucide menu chevron-down arrow-right -d snippets -p icon-
```

Use `<library>:<variant>` to pick a variant (`lucide`, `heroicons`, ...):

```bash
npx @ckreidl/sis add <library>:<variant> <icons...> -d snippets -p icon-
npx @ckreidl/sis search <library> <icon>
npx @ckreidl/sis tags <library>
npx @ckreidl/sis variants <library>
```

## Use

```liquid
{% render 'icon-menu' %}
{% render 'icon-menu', size: 32 %}
{% render 'icon-menu', class: 'text-primary' %}
{% render 'icon-menu', stroke_width: 1.5 %}
```

Do not repeat inline SVG across sections. Keep file names stable and descriptive.
