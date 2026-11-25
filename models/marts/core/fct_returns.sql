-- Returns kept in their own fact: they arrive weeks after the sale, so they would
-- slip past the incremental lookback on fct_order_items.
with returns as (
    select * from {{ ref('stg_store__returns') }}
),

items as (
    select * from {{ ref('fct_order_items') }}
)

select
    r.return_id,
    r.order_item_id,
    i.order_id,
    i.customer_id,
    i.store_id,
    i.product_id,
    i.order_date,
    r.return_date,
    datediff(day, i.order_date, r.return_date)               as days_to_return,
    r.return_reason,
    r.returned_quantity,
    round(i.net_amount * r.returned_quantity / i.quantity, 2) as refund_amount
from returns as r
join items as i
    on r.order_item_id = i.order_item_id
