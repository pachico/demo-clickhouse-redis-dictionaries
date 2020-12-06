CREATE DATABASE IF NOT EXISTS quote;

use quote;


-- This is the DDL definition for the dictionary
-- that will fetch exchange rates from Redis

CREATE DICTIONARY IF NOT EXISTS exchange_rate
(
    currency String,
    rate Float32
)
PRIMARY KEY currency
SOURCE(REDIS(
    host 'redis'
    port 6379
    storage_type 'simple'
    db_index 0
))
LAYOUT(COMPLEX_KEY_HASHED())
LIFETIME(3600);

-- This table stores the data as is when reaches our system

CREATE TABLE IF NOT EXISTS quote_entry
(
    product_id UInt32,
    timestamp DateTime,
    quote Float32,
    currency LowCardinality(String)
)
ENGINE = Null;

-- This is the table where all quotes are converted to Euro

CREATE TABLE IF NOT EXISTS quote
(
    product_id UInt32,
    timestamp DateTime,
    quote Float32,
    currency LowCardinality(String),
    quote_eur Float32
)
ENGINE = Memory;

-- This is the materialized view that does the magic

CREATE MATERIALIZED VIEW IF NOT EXISTS quote_view
TO quote AS
SELECT
    quote_entry.product_id AS product_id,
    quote_entry.timestamp AS timestamp,
    quote_entry.quote AS quote,
    quote_entry.currency AS currency,
    round((quote_entry.quote * exchange_rate.rate), 2) AS quote_eur
FROM quote_entry LEFT JOIN exchange_rate ON quote_entry.currency = exchange_rate.currency;