# Coupons

Coupons are discount codes that shoppers apply at checkout. Merchant API v3 uses the store handle and a store API key.

## Endpoints

Base path: `/api/v3/stores/{storeHandle}/coupons`

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v3/stores/{storeHandle}/coupons` | List coupons |
| `POST` | `/api/v3/stores/{storeHandle}/coupons` | Create a coupon |
| `GET` | `/api/v3/stores/{storeHandle}/coupons/{couponId}` | Get a coupon |
| `PATCH` | `/api/v3/stores/{storeHandle}/coupons/{couponId}` | Update a coupon |
| `DELETE` | `/api/v3/stores/{storeHandle}/coupons/{couponId}` | Delete a coupon |

Use the full base URL `https://tiendu.uy` and send `Authorization: Bearer $TIENDU_API_KEY`. Individual-resource operations return a coupon object directly. List operations return `{ "data": [...], "pagination": {...} }`.

## Create a coupon

Required fields are `name`, `code`, and `discount`. Optional fields are `minimumOrderAmountInCents`, `usageLimit`, `expiresAt`, and `isEnabled`.

```bash
curl https://tiendu.uy/api/v3/stores/my-store/coupons \
  -X POST \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Spring launch",
    "code": "SPRING15",
    "discount": {
      "type": "percentage",
      "percentage": 15,
      "maxAmountInCents": 2000
    },
    "minimumOrderAmountInCents": 5000,
    "usageLimit": 100,
    "expiresAt": "2027-01-01T00:00:00.000Z",
    "isEnabled": true
  }'
```

`discount` is one of these shapes:

```json
{ "type": "percentage", "percentage": 15, "maxAmountInCents": 2000 }
{ "type": "fixed", "amountInCents": 1500 }
```

Percentage discounts require an integer from 1 to 100. `maxAmountInCents` is an optional positive integer cap, or `null`. Fixed discounts use a positive integer `amountInCents`. Monetary amounts are integer cents; for example, 300 pesos is `30000`.

`minimumOrderAmountInCents` must be a nonnegative integer or `null`. `usageLimit` is a positive integer or `null` for unlimited uses. `expiresAt` is an ISO 8601 timestamp with offset or `null`. `isEnabled` defaults to `true`.

## List and get coupons

List coupons, optionally filtered by enabled state or exact code:

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/coupons?page=1&size=20&code=SPRING15' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

`page` starts at 1; `size` ranges from 1 to 100. `enabled` filters the merchant on/off setting. `code` is matched case-insensitively after trimming.

Get a coupon by its positive numeric `couponId`, not the shopper code:

```bash
curl https://tiendu.uy/api/v3/stores/my-store/coupons/42 \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Update a coupon

Send a nonempty subset of the create fields directly in the JSON body. Omitted fields remain unchanged. Set `minimumOrderAmountInCents`, `usageLimit`, or `expiresAt` to `null` to clear them. A supplied `discount` replaces the entire discount.

```bash
curl https://tiendu.uy/api/v3/stores/my-store/coupons/42 \
  -X PATCH \
  -H "Authorization: Bearer $TIENDU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{ "isEnabled": false }'
```

`id`, `usesCount`, and timestamps are read-only. Disable a coupon if it may need to be restored; deletion is permanent.

## Delete a coupon

```bash
curl https://tiendu.uy/api/v3/stores/my-store/coupons/42 \
  -X DELETE \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

The endpoint returns the deleted coupon object. Discounts already recorded on orders remain intact.
