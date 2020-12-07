.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up: ## Starts all the containers required run the demo
	docker-compose up -d

# Interacting with Redis

redis-insert-currency-rates: ## Inserts in Redis exchange rates
	docker-compose exec redis bash -c "redis-cli mset USD 0.82 GBP 1.11"

redis-read-currency-rates: ## Reads from Redis the exchange rates
	docker-compose exec redis bash -c "redis-cli mget USD GBP "

# Interacting with ClickHouse

clickhouse-insert-quote: ## Inserts in ClickHouse random data to trigger the materialized views
	docker-compose exec clickhouse bash -c "cat /opt/queries/insert.sql | clickhouse-client"

clickhouse-read-exchange-rate: ## Reads from ClickHouse the data in the dictionary which points to Redis
	docker-compose exec clickhouse bash -c "clickhouse-client --query=\"SELECT * FROM quote.exchange_rate LIMIT 10 FORMAT PrettyCompactMonoBlock\""

clickhouse-read-quote: ## Reads from ClickHouse the data stored by the materialized view
	docker-compose exec clickhouse bash -c "clickhouse-client --query=\"SELECT * FROM quote.quote LIMIT 10 FORMAT PrettyCompactMonoBlock\""

clickhouse-read-aggregation: ## Queries basic aggregation over quotes in euros
	docker-compose exec clickhouse bash -c "clickhouse-client --query=\"SELECT product_id, median(quote_eur) FROM quote.quote GROUP BY product_id FORMAT PrettyCompactMonoBlock\""

down: ## Shuts down all the containers and removes their volume
	docker-compose down --volumes --remove-orphans
