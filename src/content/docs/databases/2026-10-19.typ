#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "SQL set operations UNION, UNION ALL, INTERSECT and EXCEPT, their column compatibility rules, plus NULL semantics, IS NULL checks and COALESCE fallbacks.",
  lang: "en",
  title: "SQL set operations and NULL value handling",
))

= SQL set operations

All SQL set operations are governed by three rules:

- The column count must be identical in all participating queries.
- Corresponding columns must have compatible data types.
- The column names in the result set are determined by the first query.

```sql
SELECT `actor_id` FROM `actors`
UNION
SELECT `actor_id` FROM `roles`;
```

The other two set operations are `INTERSECT` and `EXCEPT` (set difference). A
union can be performed with `UNION`, which removes duplicate rows from the final
result, or with `UNION ALL`, which keeps them and is therefore faster.

```sql
SELECT `employee_id` FROM `all_staff`
EXCEPT
SELECT `employee_id` FROM `managers`;
```

= `NULL`

`NULL` represents missing or unknown data. It cannot be used with the normal
math or comparison operators, since any comparison with it yields `NULL`
(unknown). Instead, we check for missing data with `IS NULL` and `IS NOT NULL`.

`COALESCE` returns the first non-`NULL` argument, so it can be used to replace a
`NULL` value with a fallback:

```sql
-- If customers.region is NULL, the result will contain 'N/A'.
SELECT COALESCE(`region`, 'N/A') AS `region` FROM `customers`;
```

In logical conditions (`AND`, `OR`), `NULL` propagates only when it can affect
the outcome: `NULL AND TRUE` is `NULL`, but `NULL AND FALSE` is `FALSE` and
`NULL OR TRUE` is `TRUE`.
