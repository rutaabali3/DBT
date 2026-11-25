select
    order_item_id,
    order_id,
    line_number,
    sku_id,
    quantity,
    unit_price
from {{ source('store', 'order_items') }}
