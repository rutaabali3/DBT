select
    store_id,
    store_code,
    store_name,
    city,
    store_type,
    iff(store_type = 'ONLINE', 'online', 'in_store') as channel,
    opened_date
from {{ source('store', 'stores') }}
