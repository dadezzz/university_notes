#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Views restrict visible data and simplify complex queries; CTEs, nested subqueries with IN, ANY, ALL, EXISTS and UNIQUE; recursive CTEs traverse hierarchies.",
  lang: "en",
  title: "Views, common table expressions and subqueries",
))

= Views

In some cases it is not desirable for all users to see the entire logical model
(all the actual relations stored in the database).

A view provides a mechanism to specify what each user can see. It is a virtual
table, created dynamically by a predefined query.

Besides security, views also provide other benefits:

- simplify long and complex queries, avoiding the need to repeat them more than
  once;
- improve readability by hiding attributes that are not needed for the task;
- present a consistent interface, allowing the structure of the underlying
  tables to be changed without modifying the consumer API;

```sql
CREATE VIEW `faculty` AS
  SELECT `id`, `name`, `dept_name` FROM `instructor`;
```

The contents of a view are not stored, but computed each time the view is
referenced, so this can affect performance.

== `WITH` clause

For simplifying a single query, there is another mechanism called *common table
expression* (CTE), which defines a named result set that only exists for the
duration of the current query:

```sql
WITH `high_earners` AS (
  SELECT `dept_name`, AVG(`salary`) AS `avg_sal`
  FROM `instructor`
  GROUP BY `dept_name`
)
SELECT `dept_name`, `avg_sal`
FROM `high_earners`
WHERE `avg_sal` > 75000;
```

= Nested queries

A subquery is an SQL query nested inside another SQL statement, called the outer
query.

Subqueries can be placed in:

- `SELECT`: calculates a computed scalar value per row;
- `FROM`: acts as a derived table or view;
- `WHERE`: used for row-level filtering based on information that depends on
  other tables (sometimes as an alternative to joins);
- `HAVING`: used for filtering groups after aggregation;

Subqueries fall into two categories:

- *Scalar subqueries*: they return exactly one row and one column, so they can
  be used anywhere a single value is expected;
- *Multiple-row subqueries*: they return multiple rows with one or more columns,
  so they cannot be used where a scalar is expected; instead, they are combined
  with operators such as `IN`, `ANY` or `ALL`;

In general, a non-correlated subquery is evaluated once and its result is then
used by the outer query. A correlated subquery, instead, references columns of
the outer query, so it must be evaluated once per outer row.

```sql
-- Scalar subquery in SELECT.
SELECT
  `name`, FORMAT(`salary`, 2),
  (SELECT FORMAT(AVG(`salary`), 2) FROM `instructor`) AS `avg_salary`
FROM `instructor`;
```

```sql
-- Scalar subquery in HAVING.
SELECT `dept_name`, AVG(`salary`) AS `dept_avg`
FROM `instructor`
GROUP BY `dept_name`
HAVING AVG(`salary`) > (SELECT AVG(`salary`) FROM `instructor`);
```

```sql
-- Multiple-row subquery for filtering.
SELECT DISTINCT `course_id`
FROM `section`
WHERE `semester` = 'Fall'
  AND `year` = 2009
  AND `course_id` NOT IN (
    SELECT `course_id`
    FROM `section`
    WHERE `semester` = 'Spring' AND `year` = 2008
  );
```

The result of a subquery can also be tested with dedicated operators:

- The `EXISTS` operator returns `true` if the subquery returns at least one row,
  and `false` otherwise.
- The `UNIQUE` operator returns `true` if the subquery returns no duplicate
  rows, and `false` otherwise.

= Recursive queries

A recursive query is a query that references its own output. It is handled using
a CTE with the `RECURSIVE` keyword.

These queries are often used to traverse hierarchical data, such as
organizational charts, bills of material, folder structures or graph networks.

A recursive CTE is composed of two parts:

- an anchor member that provides the initial seed rows;
- a recursive member that joins back to the CTE itself;

```sql
-- Self-referential table (`manager_id` refers to `employee_id`).
CREATE TABLE `employees` (
  `employee_id` INT PRIMARY KEY,
  `name` VARCHAR(50),
  `manager_id` INT,
  CONSTRAINT `fk_manager`
    FOREIGN KEY (`manager_id`) REFERENCES `employees`(`employee_id`)
);

-- Find the subordinates of employee 2.
WITH RECURSIVE `subordinate_tree` AS (
  -- Anchor member: start from the given employee.
  SELECT `employee_id`, `name`, `manager_id`, 1 AS `depth`
  FROM `employees`
  WHERE `employee_id` = 2
  UNION ALL
  -- Find employees whose manager is in the tree
  SELECT `e`.`employee_id`, `e`.`name`, `e`.`manager_id`, `st`.`depth` + 1
  FROM `employees` `e`
  JOIN `subordinate_tree` `st` ON `e`.`manager_id` = `st`.`employee_id`
)
SELECT * FROM `subordinate_tree`;
```
