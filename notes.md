#dbt notes

- Setting up dbt cloud to work with BigQuery is pretty tricky using their docs.  I found this [playlist](https://www.youtube.com/playlist?list=PL0QYlrC86xQlp-eOGzGllDxYese4Ki_6A) to be better.

## Building your first model

We can run the below query in BigQuery, which is a data transformation using SQL. 


```sql
with customers as (

    select
        id as customer_id,
        first_name,
        last_name

    from dbt-tutorial.jaffle_shop.customers

),

orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from dbt-tutorial.jaffle_shop.orders

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * from final
```

Save the above SQL into dbt cloud as `models/dim_customers.sql`. You can preview it but also run `dbt run`, which will create a view.  If we look at the logs you will see something that looks like this:

```
 create or replace view `analytics-392917`.`dbt_hhusain`.`dim_customers`
  OPTIONS()
  as with customers as (
    ...
```

If we navigate to BigQuery, we will see this view:

![](notes_imgs/2023-07-15-11-51-41.png)



