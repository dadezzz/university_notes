#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "String comparison, LIKE pattern matching, concatenation, case conversion, length, substrings, trimming, and the CASE expression for conditional results.",
  lang: "en",
  title: "SQL string functions, pattern matching, and CASE",
))

= String functions

Text strings can be compared using the equality (`=`) and inequality (`!=`)
operators to filter records based on exact matches. String comparisons are case-
and accent-insensitive. To compare strings byte by byte, use `BINARY`.

== Pattern matching

The `LIKE` operator allows pattern matching using wildcards: `%` for zero or
more characters and `_` for exactly one character.

```sql
-- Select where company name starts with 'A'.
SELECT `name` FROM `customers` WHERE `companyName` LIKE 'A%';
```

== Concatenation

`CONCAT` returns the string that results from concatenating the arguments. It
may take one or more arguments, and numeric arguments are converted to their
equivalent string form.

== Upper/Lower case

The `UPPER` and `LOWER` functions convert the argument string to all uppercase
or all lowercase, respectively.

== Length

The `LENGTH` function returns the length of a string in bytes; use `CHAR_LENGTH`
to count characters.

== Substrings

`SUBSTRING` extracts a portion of a string based on a starting position and a
specified length.

== Trim

- `TRIM` removes surrounding whitespace.
- `REPLACE` replaces specific substrings with alternate text. It performs a
  case-sensitive match.

= `CASE`

`CASE` is a standard SQL expression that evaluates conditions sequentially and
returns the result of the first condition that is met.

```sql
SELECT `employee_id`, `salary`,
  CASE
    WHEN `salary` > 80000 THEN 'high'
    WHEN `salary` BETWEEN 50000 AND 80000 THEN 'medium'
    ELSE 'low'
  END AS `salary_tier`
FROM `employee`;
```

In the simple form, where `CASE` compares a single expression against constant
`WHEN` values, the DBMS performs a simple equality check.

It is recommended to always include an `ELSE` clause; otherwise, `CASE` returns
`NULL` when no condition is met.
