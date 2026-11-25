{% macro discounted_amount(price, discount, scale=2) %}
    round({{ price }} * (1 - {{ discount }}), {{ scale }})
{% endmacro %}
