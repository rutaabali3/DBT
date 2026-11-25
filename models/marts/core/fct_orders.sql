with orders as (
    select * from {{ ref('stg_store__orders') }}
),

stores as (
    select * from {{ ref('stg_store__stores') }}
),

item_totals as (
    select
        order_id,
        count(*)           as item_count,
        sum(quantity)      as units,
        sum(gross_amount)  as gross_amount,
        sum(net_amount)    as net_amount,
        sum(gross_profit)  as gross_profit
    from {{ ref('fct_order_items') }}
    group by order_id
)

select
    o.order_id,
    o.customer_id,
    o.store_id,
    s.channel,
    s.city                              as store_city,
    o.ordered_at,
    o.order_date,
    o.order_status,
    o.payment_method,
    o.promo_code,
    coalesce(i.item_count, 0)           as item_count,
    coalesce(i.units, 0)                as units,
    coalesce(i.gross_amount, 0)         as gross_amount,
    coalesce(i.net_amount, 0)           as net_amount,
    coalesce(i.gross_profit, 0)         as gross_profit,
    o.shipping_fee,
    iff(o.order_status = 'CANCELLED', 0, coalesce(i.net_amount, 0) + o.shipping_fee) as order_total
from orders as o
join stores as s
    on o.store_id = s.store_id
left join item_totals as i
    on o.order_id = i.order_id
