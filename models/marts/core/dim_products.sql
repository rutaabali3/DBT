select
    product_id,
    product_code,
    product_name,
    category,
    department,
    fabric,
    brand,
    list_price,
    unit_cost,
    round((list_price - unit_cost) / list_price, 2) as margin_pct,
    case
        when list_price < 3000 then 'budget'
        when list_price < 7000 then 'standard'
        else 'premium'
    end as price_band,
    launch_date,
    is_active
from {{ ref('stg_store__products') }}
