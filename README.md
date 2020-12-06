# Demo ClickHouse Redis Dictionary

Simple demo to show how to use `Redis` as source for `ClickHouse` external dictionary.

## Requirements

- `docker-compose`
- `make` (if you want to use it to easily run it, otherwise you can always run the commands by hand)

## Run it

The `Makefile` is self documented. Type `make help` to get its content:

```txt
up                             Starts all the containers required run the demo
down                           Shuts down all the containers and removes their volume
redis-insert-currency-rates    Inserts in Redis exchange rates
redis-read-currency-rates      Reads from Redis the exchange rates
clickhouse-insert-quote        Inserts in ClickHouse random data to trigger the materialized views
clickhouse-read-exchange-rate  Reads from ClickHouse the data in the dictionary which points to Redis
clickhouse-read-quote          Reads from ClickHouse the data stored by the materialized view
clickhouse-read-aggregation    Queries basic aggregation over quotes in euros
```

Execute the commands in this order to run the demo.
