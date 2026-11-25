-- Sold order lines (cancelled orders are not sales), with product, store and promo joined in,
-- and the money worked out once.
with items as (
    select * from {{ ref('stg_store__order_items') }}
),

orders as (
    select * from {{ ref('stg_store__orders') }}
    where order_status != 'CANCELLED'
),

skus as (
    select * from {{ ref('stg_store__skus') }}
),

products as (
    select * from {{ ref('stg_store__products') }}
),

promos as (
    select * from {{ ref('promo_codes') }}
)

select
    i.order_item_id,
    i.order_id,
    o.order_date,
    o.customer_id,
    o.store_id,
    i.sku_id,
    s.product_id,
    s.colour,
    s.size,
    i.quantity,
    i.unit_price,
    i.quantity * i.unit_price                    as gross_amount,
    coalesce(pc.discount_pct, 0)                 as discount_pct,
    {{ discounted_amount('i.quantity * i.unit_price', 'coalesce(pc.discount_pct, 0)') }} as net_amount,
    i.quantity * p.unit_cost                     as cost_amount,
    net_amount - cost_amount                     as gross_profit
from items as i
join orders as o
    on i.order_id = o.order_id
join skus as s
    on i.sku_id = s.sku_id
join products as p
    on s.product_id = p.product_id
left join promos as pc
    on o.promo_code = pc.promo_code
