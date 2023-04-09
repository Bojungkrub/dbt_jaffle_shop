WITH payments AS (
    SELECT
        id AS payment_id,
        order_id,
        payment_method,
        amount,

        -- amount is stored in cents, convert it to dollars
        {{ cents_to_dollars('amount') }} AS amount_dollar

    FROM {{ source('jaffle_shop', 'raw_payments') }}
)

SELECT * FROM payments