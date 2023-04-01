WITH payments AS (
    SELECT
        id AS payment_id,
        order_id,
        payment_method,
        amount
    FROM {{ source('jaffle_shop', 'raw_payments') }}
)

SELECT * FROM payments