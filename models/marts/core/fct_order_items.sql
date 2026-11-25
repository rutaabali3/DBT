{{
    config(
        materialized = 'incremental',
        unique_key = 'order_item_id',
        incremental_strategy = 'merge',
        on_schema_change = 'append_new_columns'
    )
}}

select * from {{ ref('int_order_items__priced') }}

{% if is_incremental() %}
  -- only rows newer than what we already have, with a 3-day lookback for late arrivals
  where order_date >= (select dateadd(day, -3, max(order_date)) from {{ this }})
{% endif %}
