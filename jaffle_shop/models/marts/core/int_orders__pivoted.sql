{%- 
    set payment_methods = [
        'bank_transfer', 'coupon', 'credit_card', 'gift_card'
    ]
-%}

WITH payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
),

pivoted AS (
    SELECT
        order_id
        
        {% for payment_method in payment_methods %}

        ,sum( 
            CASE
                WHEN payment_method = '{{ payment_method }}' THEN amount
                ELSE 0
            END
        ) AS {{ payment_method }}_amount

        -- {% if not loop.last %}
        --     ,
        -- {% endif %}

        {% endfor %}

-- Jinja มีปัญหาตรง ', FROM' loop สุดท้าย
-- ต้องแก้ปัญหาด้วยการเอา ',' มาไว้บรรทัดหน้า sum หรือเขียน if not loop.last

-- ถ้าใช้ Jinja จะไม่ต้องเขียน SQL ยาวๆ ข้างล่าง
    --     sum(
    --         CASE
    --             WHEN payment_method = 'bank_transfer' THEN amount
    --             ELSE 0
    --         END
    --     ) AS bank_transfer_amount,
        
    --     sum( 
    --         CASE
    --             WHEN payment_method = 'coupon' THEN amount
    --             ELSE 0
    --         END
    --     ) AS coupon_amount,

    --     sum( 
    --         CASE
    --             WHEN payment_method = 'credit_card' THEN amount
    --             ELSE 0
    --         END
    --     ) AS credit_card_amount,

    --     sum( 
    --         CASE
    --             WHEN payment_method = 'gift_card' THEN amount
    --             ELSE 0
    --         END
    --     ) AS gift_card_amount

    FROM payments
    GROUP BY 1
)

SELECT * FROM pivoted