# Stock and pricing

## Price

- Prices are integers in **cents** of the product's `currency`: `UYU` (default) or `USD`. $12.50 is `1250`.
- `basePriceInCents: null` means **no price**: shoppers must ask for it and the product **cannot be added to the cart**.
- `baseCompareAtPriceInCents` is the "before" price, shown crossed out next to the price. It is a display value; it does not apply a discount.
- Changing the product's base price updates only the variants that still share the old base price. Variants with their own price keep it.
- Changing `currency` on a product whose variants have different prices requires reviewing those prices.

## Stock

- Stock lives on each variant. `stock: null` is **unlimited**.
- Each sale subtracts the ordered quantity from the variant's stock. At 0 the variant cannot be added to the cart.
- `inStock` in `products_list` returns products with at least one variant that has stock above 0 or unlimited stock.
- Product-level `stock` and `sku` apply to the default variant of a simple product.

## Weight and shipping

- `baseWeightInGrams` (and each variant's `weightInGrams`) feeds shipping prices that depend on weight. `null` is treated as 0.
- Digital products (`isPhysical: false`) are not shipped.

## Discounts

Coupons are a separate mechanism applied at checkout; see the discounts guide.
