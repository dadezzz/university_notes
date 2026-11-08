#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Window functions compute values across related rows without collapsing them: OVER clauses, ROW_NUMBER, RANK, DENSE_RANK, NTILE, LAG, LEAD and frame modes.",
  lang: "en",
  title: "SQL window functions, ranking and window frames",
))

= Window functions

A window function performs a calculation across a set of table rows that are
related to the current row. Unlike aggregate functions with `GROUP BY`, window
functions do not collapse the selected rows into a single result row.

```sql
-- FUNCTION_NAME is a window function.
-- OVER defines the window the function operates on.
FUNCTION_NAME(expression) OVER (
  [PARTITION BY `partition_column`]  -- Similar to GROUP BY.
  [ORDER BY `sort_column` [ASC/DESC]]
  [ROWS/RANGE frame_clause] -- Restricts which rows are visible to the function.
)
```

== `ROW_NUMBER`

Assigns a unique sequential integer to each row, starting at 1.

```sql
SELECT
  `id`, `dept_name`, `salary`,
  ROW_NUMBER() OVER (PARTITION BY `dept_name` ORDER BY `salary` DESC) AS `row_num`
FROM `instructor`;
```

== `RANK`

Assigns a rank to each row based on the `ORDER BY` clause. Leaves gaps in the
ranking numbers when there are ties.

```sql
SELECT
  `id`, `salary`,
  RANK() OVER (ORDER BY `salary` DESC) AS rnk,
  DENSE_RANK() OVER (ORDER BY `salary` DESC) AS dense_rnk -- Like RANK but doesn't leave gaps.
FROM `instructor`;
```

#starlight.note(title: "Ranking NULL values", [
  When `NULL` values are ranked, they can be treated as the highest or lowest
  values. Some SQL implementations let the user specify where they should occur:

  ```sql
  ORDER BY `column_name` NULLS FIRST/LAST
  ```
])

== Other functions

- `NTILE`: divides rows into a specified number of groups (buckets) of
  approximately the same size;
- `LAG` and `LEAD`: allow accessing data from a previous or subsequent row
  without a self join;
- `FIRST_VALUE` and `LAST_VALUE`: retrieve the first or last value in an ordered
  window frame;

== Window specification

The window frame can be specified by including a number of preceding or
following rows, or by using the `UNBOUNDED` keyword to extend the frame to the
beginning or the end of the partition. The `ROWS` mode counts physical rows,
while the `RANGE` mode also includes the rows that tie with the current row on
the `ORDER BY` expression.

```sql
SELECT
  `transaction_date`, `amount`,
  SUM(`amount`) OVER (
    ORDER BY `transaction_date`
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS `running_total`
FROM `transactions`;
```
