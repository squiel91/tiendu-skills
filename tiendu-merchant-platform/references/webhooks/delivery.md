---
title: Webhook delivery and retries
description: Design a webhook receiver to handle retries, duplicate events, and timeouts.
---

Webhook delivery is **at least once**, so an event may arrive more than once. Deduplicate using the payload `id` or the `Tiendu-Event-Id` header.

Tiendu makes up to three delivery attempts. A `2xx` response marks delivery successful. Responses `408`, `425`, `429`, and `5xx`, as well as timeouts, may be retried. Requests time out after 10 seconds.

Verify and record the event, then return `2xx` promptly and process it asynchronously. The callback URL must use HTTPS, resolve to a public host, and contain no embedded credentials.
