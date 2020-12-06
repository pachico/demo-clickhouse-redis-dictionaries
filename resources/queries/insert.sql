INSERT INTO quote.quote_entry SELECT
    transform(number % 2, [0, 1], [1001, 1002], 0) AS product_id,
    now() AS timestamp,
    round(cbrt(rand()), 2) AS quote,
    transform(number % 2, [0, 1], ['USD', 'GBP'], '') AS currency
FROM numbers(1, 10000);
