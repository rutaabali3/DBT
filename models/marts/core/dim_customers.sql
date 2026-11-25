with customers as (
    select * from {{ ref('stg_store__customers') }}
),

order_stats as (
    select
        customer_id,
        min(order_date)   as first_order_date,
        max(order_date)   as most_recent_order_date,
        count(*)          as number_of_orders,
        sum(order_total)  as lifetime_spend
    from {{ ref('fct_orders') }}
    where order_status != 'CANCELLED'
    group by customer_id
)

select
    c.customer_id,
    c.full_name,
    c.email,
    c.city,
    c.gender,
    datediff(year, c.date_of_birth, current_date)  as age,
    case
        when age < 25 then '16-24'
        when age < 35 then '25-34'
        when age < 45 then '35-44'
        else '45+'
    end                                             as age_band,
    c.signup_date,
    c.marketing_opt_in,
    s.first_order_date,
    s.most_recent_order_date,
    coalesce(s.number_of_orders, 0)                 as number_of_orders,
    coalesce(s.lifetime_spend, 0)                   as lifetime_spend,
    case
        when lifetime_spend >= 250000 then 'Platinum'
        when lifetime_spend >= 150000 then 'Gold'
        when lifetime_spend >= 75000  then 'Silver'
        else 'Bronze'
    end                                             as loyalty_tier
from customers as c
left join order_stats as s
    on c.customer_id = s.customer_id
