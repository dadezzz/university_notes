#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Combining tables with Cartesian products and joins: NATURAL JOIN, INNER JOIN with ON conditions, and LEFT, RIGHT, and FULL OUTER JOIN with NULL padding.",
  lang: "en",
  title: "Joining tables: natural, inner, and outer joins",
))

= Joins

Using a Cartesian product or a join, we can `SELECT` from multiple SQL tables.

```sql
-- For each row in actors, all rows in roles.
SELECT * FROM `actors`, `roles`;
```

Sometimes tables contain columns with the same name; in that case the columns
need to be qualified:

```sql
SELECT `actors`.`actor_id`, `roles`.`actor_id` FROM `actors`, `roles`;
```

Rows can be filtered in the `WHERE` clause:

```sql
SELECT `name`, `surname`, `role`
FROM `actors`, `roles`
WHERE
  `actors`.`actor_id` = `roles`.`actor_id`;
```

The `WHERE` condition contains both the rules that build the data and the rules
that filter it, resulting in confusing queries. To address this, the SQL
standard introduced a `JOIN` operator, used to distinguish conditions that join
tables from those that filter them.

The main types of join are the following:

- `NATURAL JOIN`: joins two tables on attributes that share the same name and
  datatype. The resulting table contains all the attributes of both tables but
  retains only one copy of each common column.
- `INNER JOIN`: joins two tables on the columns explicitly specified in the `ON`
  clause. The resulting table contains all the attributes of both tables,
  including the common columns.
- `OUTER JOIN`: like an inner join, but it keeps unmatched rows from one
  (`LEFT OUTER JOIN`, `RIGHT OUTER JOIN`) or both (`FULL OUTER JOIN`) tables.
  The missing values on the non-matching side are filled with `NULL`.
