-- What the business asks every Monday: how much did we sell, where, and of what?
select
    date_trunc(month, i.order_date)  as sales_month,
    s.channel,
    s.city                           as store_city,
    p.department,
    p.category,
    count(distinct i.order_id)       as orders,
    sum(i.quantity)                  as units,
    sum(i.net_amount)                as net_revenue,
    sum(i.gross_profit)              as gross_profit
from {{ ref('fct_order_items') }} as i
join {{ ref('dim_stores') }} as s
    on i.store_id = s.store_id
join {{ ref('dim_products') }} as p
    on i.product_id = p.product_id
group by all
