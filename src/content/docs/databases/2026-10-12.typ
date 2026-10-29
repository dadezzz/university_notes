#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "SQL UPDATE and DELETE syntax, table-level UNIQUE constraints, ALTER TABLE column changes, and foreign key actions like CASCADE, SET NULL, and SET DEFAULT.",
  lang: "en",
  title: "Row updates, table constraints, and foreign keys",
))

= SQL UPDATE and DELETE

An `UPDATE` query follows this syntax:

```sql
UPDATE <TABLE_NAME>
SET <COLUMN_NAME> = <VALUE>,
    <COLUMN_NAME> = <VALUE>
WHERE <CONDITION>;
```

A `DELETE` query:

```sql
DELETE FROM <TABLE_NAME> WHERE <CONDITION>;
```

In most cases, the condition matches the primary key of the row to be updated or
deleted.

= Table constraints

```sql
CREATE TABLE `roles` (
  `actor_id` INT REFERENCES `actors`(`id`),
  `movie_id` INT REFERENCES `movies`(`id`),
  `role` VARCHAR(30),
  CONSTRAINT unique_record UNIQUE (`actor_id`, `movie_id`, `role`)
);
```

In this case, we want the `(actor_id, movie_id, role)` tuple to be unique in the
table, but setting a `UNIQUE` constraint on each column would be too
restrictive. The solution is to add a `UNIQUE` constraint at the table level.

= Changing table structure

Tables can be modified without dropping and re-creating them:

```sql
-- Adds a new column named score. On already existing rows we must set a
-- default value or allow NULL.
ALTER TABLE `roles` ADD COLUMN `score` INT NOT NULL DEFAULT 0;
ALTER TABLE `roles` DROP COLUMN `score`;
ALTER TABLE `roles` RENAME COLUMN `role` TO `character`;

-- Another way to add the table level constraint seen above.
ALTER TABLE `roles` ADD CONSTRAINT `unique_actor_movie_character`
  UNIQUE (`actor_id`, `movie_id`, `character`);
```

= Referential integrity

When declaring a foreign key, we can specify what to do when the parent record
is deleted or updated:

- `ON DELETE RESTRICT / NO ACTION` (default): rejects the deletion if child
  records exist;
- `ON DELETE CASCADE`: automatically deletes all matching child rows when the
  parent row is deleted;
- `ON DELETE SET NULL`: sets the child table's foreign key column to NULL;
- `ON DELETE SET DEFAULT`: sets the child table's foreign key column to its
  declared DEFAULT value;
