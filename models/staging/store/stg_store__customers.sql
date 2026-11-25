select
    customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name,
    lower(email)                   as email,
    phone,
    city,
    case gender when 'F' then 'Female' when 'M' then 'Male' end as gender,
    date_of_birth,
    signup_date,
    marketing_opt_in
from {{ source('store', 'customers') }}
