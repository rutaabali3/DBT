{#
  dev  -> dbt_<yourname>_staging, dbt_<yourname>_marts   (everyone gets their own sandbox)
  prod -> staging, marts                                 (clean names for analysts)
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- elif target.name == 'prod' -%}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {{ target.schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
