---
title: API limits and fair use
description: Merchant API v3 request quotas and per-store resource safety caps.
---

Merchant API v3 quotas and resource caps help keep Tiendu stable and responsive for every store. They apply under the [Reasonable Use Policy](https://tiendu.uy/politica-de-uso-razonable), which forms part of the seller [Terms and Conditions](https://tiendu.uy/terminos-y-condiciones).

## Merchant API v3 request quotas

Each authenticated Merchant API v3 request is counted against these rolling windows:

| Window     | Maximum requests |
| ---------- | ---------------: |
| 1 second   |                5 |
| 60 seconds |              200 |
| 60 minutes |            6,000 |

The quota is shared by all API keys for the same store. When a request exceeds a limit, the API returns `429 Too Many Requests` and a `Retry-After` header with the number of seconds to wait before retrying. Honor that value and reduce request frequency before continuing.

Avoid unnecessary polling and large bursts of concurrent requests. Do not run load tests, scans, or automation that could degrade the service without prior authorization. Contact [hola@tiendu.uy](mailto:hola@tiendu.uy) to coordinate an unusually large migration or integration.

## Per-store resource safety caps

These operational safety caps are shared across plans. They are not commercial plan quotas. A plan described as having unlimited products has no commercial product fee or plan upgrade based only on catalog size; the safety caps still apply.

| Resource                 | Maximum per store |
| ------------------------ | ----------------: |
| Products                 |            10,000 |
| Product variants         |           100,000 |
| Collections (categories) |             1,000 |
| Images                   |           250,000 |
| Pages                    |             1,000 |
| Blog posts               |             5,000 |
| Coupons                  |             1,000 |
| Menus                    |             1,000 |
| Menu items               |            50,000 |
| Attributes               |             5,000 |
| Attribute values         |            50,000 |
| Redirects                |            10,000 |
| Functions                |             1,000 |
| Theme files              |            10,000 |

Theme storage has additional size caps:

| Theme storage                      | Maximum |
| ---------------------------------- | ------: |
| Total storage per theme or preview | 100 MiB |
| Individual theme asset             |  25 MiB |
| Individual editable theme file     |   5 MiB |

Tiendu may pause imports or processes and request correction or removal of abusive resources to protect the service. The Reasonable Use Policy provides for contacting the seller and offering a reasonable opportunity to correct an issue unless there is an urgent security or availability risk.

## List pagination

For paginated Merchant API v3 list endpoints, `size` is generally limited to 1–100 items per response and defaults to 20. Check the endpoint reference for its exact query parameters. This per-request page size is separate from the per-store resource caps above.
