---
title: Errors
description: HTTP status codes and Problem Details for Merchant API v3.
---

Merchant API v3 uses HTTP status codes to distinguish successful requests from failures. Error responses have `Content-Type: application/problem+json` and follow [Problem Details (RFC 9457)](https://www.rfc-editor.org/rfc/rfc9457.html). They are separate from successful JSON responses.

```http
HTTP/1.1 409 Conflict
Content-Type: application/problem+json
```

```json
{
  "type": "https://docs.tiendu.uy/api/reference/errors#duplicate-coupon-code",
  "title": "Coupon code already exists",
  "status": 409,
  "detail": "A coupon with this code already exists in the store",
  "errors": [{ "pointer": "#/code", "detail": "Code already exists in this store" }]
}
```

`type` is a stable URL identifying the problem. Use it and the HTTP status for programmatic decisions; `title` and `detail` are human-readable. `status` repeats the HTTP response status. `errors`, when present, identifies invalid fields with JSON pointers. For JSON bodies, `#/code` points to the `code` field; query parameters use pointers such as `#/query/page`.

## Problem types

| HTTP status | Type | When it occurs |
| --- | --- | --- |
| 400 | [Invalid JSON body](#invalid-json) | The request body is not valid JSON. |
| 400 | [Bad Request](#bad-request) | Other malformed request, including editing or removing a store owner collaborator, or an attribute create/update with no usable values. |
| 401 | [Invalid API key](#invalid-api-key) | Missing, invalid, or revoked store key. |
| 403 | [Forbidden](#forbidden) | Authenticated request is not allowed, including store resource safety limits. |
| 404 | [Not Found](#not-found) | Store or resource does not exist or is outside the key's store. |
| 409 | [Coupon code already exists](#duplicate-coupon-code) | Another coupon in this store uses the code, regardless of case. |
| 409 | [Handle already exists](#duplicate-handle) | Another page, blog post, or menu in this store already uses the handle. |
| 409 | [URL rule source already exists](#duplicate-url-rule) | Another URL rule uses this source and matching mode. |
| 409 | [Subscriber email already exists](#duplicate-email) | Another subscriber in this store already uses the email. |
| 409 | [Conflict](#conflict) | Other resource conflict, including an email that is already a store collaborator, or overlapping shipping-rule location IDs. |
| 412 | [Subscription required](#subscription-required) | Store billing does not permit API access when enforcement is enabled. |
| 415 | [Unsupported Media Type](#unsupported-media-type) | A JSON body is required but `Content-Type` is not `application/json`. |
| 422 | [Validation failed](#validation-error) | JSON or query fields fail validation. |
| 429 | [Rate limit exceeded](#rate-limit-exceeded) | A Merchant API v3 store request quota has been exceeded. |
| 500 | [Internal Server Error](#internal-error) | An unexpected server error. |

## Invalid JSON

The request body cannot be parsed as JSON. Correct the syntax and retry.

## Bad Request

The request is malformed for a reason other than invalid JSON or field validation. Collaborator updates and deletes also use this type when the target is already a store owner (`Store owners cannot be edited.` / `Store owners cannot be removed.`). Creating or updating an attribute with no usable values after trimming returns this type (`At least one attribute value is required`).

## Invalid API key

Send a valid store key as `Authorization: Bearer <key>`. A revoked key cannot be used again. HTTP 401 also includes a `WWW-Authenticate` header.

## Forbidden

The authenticated request is not permitted. Store-key requests to a different store return 404 to avoid revealing that store's existence. Create and update operations that would exceed a store resource safety limit (for example attributes or attribute values) also return this type.

## Rate limit exceeded

The store has exceeded a rolling Merchant API v3 request quota. Wait for the number of seconds in the `Retry-After` response header before retrying, then reduce request frequency. Quotas are shared by all API keys for that store; see [API limits and fair use](limits.md).

## Not Found

The store handle or requested resource cannot be accessed with this key. Coupon, page, blog post, menu, redirect, external payment method, subscriber, review, collaborator, customer, customer address, shipping rule, and attribute IDs are scoped to the store in the URL. Delivery settings are store-scoped under `/delivery-settings`. A customer ID is only found when that user has at least one order in the store.

## Duplicate coupon code

Coupon codes are trimmed and case-insensitive within a store. Choose a different code. The response includes an `errors` entry pointing to `#/code`.

## Duplicate handle

Page, blog post, and menu handles are unique within a store after normalization. Choose a different handle. The response includes an `errors` entry pointing to `#/handle`.

## Duplicate URL rule

URL rule `from` values are unique for the same matching mode within a store after trimming and slash normalization. An exact rule may coexist with a prefix rule at the same source. Choose a different `from` or change `exactMatch`. The response includes an `errors` entry pointing to `#/from`.

## Duplicate email

Subscriber emails are unique within a store after trimming. Exact match is case-sensitive. Choose a different email. The response includes an `errors` entry pointing to `#/email`.

## Conflict

The resource state conflicts with the requested operation. This type is reserved for conflicts other than a duplicate coupon code, page, blog post, or menu handle, URL rule source, or subscriber email. Creating a collaborator whose email is already a member of the store returns this type (`The collaborator is already in this store.`). Creating or updating a shipping rule whose `leafLocationIds` overlap another rule in the store also returns this type (`Location IDs overlap with existing shipping rules: …`).

## Subscription required

The store needs an active subscription before its Merchant API can be used, when billing enforcement is enabled.

## Unsupported Media Type

Send `Content-Type: application/json` for POST and PATCH requests with JSON bodies.

## Validation error

The `errors` array identifies each invalid field. For example:

```json
{
  "type": "https://docs.tiendu.uy/api/reference/errors#validation-error",
  "title": "Validation failed",
  "status": 422,
  "detail": "Request validation failed",
  "errors": [{ "pointer": "#/discount/percentage", "detail": "Too big: expected number to be <=100" }]
}
```

Use the pointer to locate the field. The detail text may change; do not parse it as a code.

## Internal error

An unexpected failure occurred. The response omits internal details. Retry later, or contact Tiendu support if it persists.
