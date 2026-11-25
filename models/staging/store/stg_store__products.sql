select
    product_id,
    product_code,
    product_name,
    category,
    department,
    fabric,
    brand,
    price               as list_price,
    cost                as unit_cost,
    launch_date,
    status = 'ACTIVE'   as is_active
from {{ source('store', 'products') }}
