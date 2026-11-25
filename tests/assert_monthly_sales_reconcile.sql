-- The report must add up to the fact table it is built from. 0 rows back: pass.
select
    (select sum(net_revenue) from {{ ref('rpt_monthly_sales') }}) as report_total,
    (select sum(net_amount)  from {{ ref('fct_order_items') }})   as fact_total
where abs(report_total - fact_total) > 1
