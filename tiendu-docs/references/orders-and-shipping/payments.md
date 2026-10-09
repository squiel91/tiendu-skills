# Payments

A store accepts payment in these ways. Bank accounts and Mercado Pago are configured in **Ajustes → Negocio → Cobros**.

## Mercado Pago

- Connected with an OAuth login (**Conectar Mercado Pago**). Payments are processed in the authorized account. **Desconectar** stops Mercado Pago payments until it is reconnected.
- **Ajuste de precio** is a percentage applied to the whole order total (items after the coupon, plus any shipping paid now) when the shopper pays with Mercado Pago. Positive adds a surcharge, negative gives a discount, down to -99. The amount is stored on the order as `paymentMethodAdjustmentAmountInCents`.
- The order waits in `payment-pending` until Mercado Pago confirms the payment.

## Bank transfers (external payment methods)

- Bank accounts the shopper pays by transfer or deposit. They appear as payment options at checkout, with the account data in the order email.
- Fields: `bank`, `accountHolder`, `accountNumber`, `isEnabled`; `methodType` is always `bank_transfer`.
- Disabling hides the option without deleting it. Deleting is a soft delete.
- The order stays `payment-pending` until the seller changes its status.

## Custom payment options

The metadata entry `--extra-payment-methods` can define more options, each with `title`, `key`, `description` (shown when selected), `emailText` (sent with the order), `priceAdjustmentPercentage` (-99 or more; negative is a discount) and `isEnabled`. They appear at checkout next to the others. Edit them with the metadata tools.

## Pay on delivery

`enablePaidOnDelivery` in the delivery settings lets the shopper pay the shipping on delivery for the delivery services that support it.

## Interfaces

| Task | Tool | REST v3 |
|---|---|---|
| Bank transfers | `external-payment-methods_list`, `_create`, `_update`, `_delete` | `/external-payment-methods`, `/external-payment-methods/{externalPaymentMethodId}` |
| Custom payment options | `metadata_get`, `metadata_update` on `--extra-payment-methods` | `/metadata/{metadataKey}` |

Mercado Pago can be connected only in the Merchant Center.
