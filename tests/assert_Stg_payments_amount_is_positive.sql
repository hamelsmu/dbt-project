-- Refunds have a negative amount, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail.

with payments as (
    select * from {{ ref('stg_payments') }}
)

select
    order_id,
    sum(amount) as total_amount
from payments
group by order_id
having total_amount < 0
