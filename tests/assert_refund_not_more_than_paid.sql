-- A customer can never get back more than they paid for that line.
-- A singular test passes when it returns zero rows.
select
    r.return_id,
    r.refund_amount,
    i.net_amount
from {{ ref('fct_returns') }} as r
join {{ ref('fct_order_items') }} as i
    on r.order_item_id = i.order_item_id
where r.refund_amount > i.net_amount
