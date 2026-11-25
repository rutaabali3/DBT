select
    order_id,
    customer_id,
    store_id,
    ordered_at,
    ordered_at::date   as order_date,
    payment_method,
    upper(promo_code)  as promo_code,
    order_status,
    shipping_fee
from {{ source('store', 'orders') }}
