select
    sku_id,
    sku_code,
    product_id,
    colour,
    size
from {{ source('store', 'skus') }}
