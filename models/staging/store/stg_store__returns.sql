select
    return_id,
    order_item_id,
    returned_at        as return_date,
    reason             as return_reason,
    returned_quantity
from {{ source('store', 'returns') }}
