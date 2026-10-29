#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Relational database structure through tables, rows, schemas, domains and NULL, plus client-server architecture and SQL create, insert and select examples.",
  lang: "en",
  title: "Relational model: tables, schemas, domains and SQL",
))

= Relational databases

Relational databases are a type of database where data can reference other
entries. Some popular projects are PostgreSQL, MariaDB and SQLite3. In the
course we will stick with MariaDB.

Most DBMSs (Database Management Systems) are based on a client-server
architecture, where multiple clients connect via some protocol. SQLite3 is an
exception since it is a library providing structured access to a file.

== Structure

A relational database is a collection of *tables*, each with a unique name.

A *row* of the table is a tuple of data that represents a relationship: e.g.,
the relationship between the ID column and the other data columns. The order of
rows in the table is irrelevant: if we want a specific order, we must request
it.

Relations between tuples of different tables are expressed using a common value.
DBMSs may use pointers to deduplicate the data, but the model keeps the value to
stay independent of the physical structure.

For practical purposes, each tuple must be unique within its table: the
relational model treats a table as a set, so identical rows are not allowed.
SQL, however, permits duplicate rows, and creating them is often an unsound
practice.

#starlight.note([
  A tuple is an ordered sequence of values, even of different types.
])

Tables are described by a *schema* that defines attributes or columns. The set
of allowed values for each attribute is called the *domain* of the attribute.
The special value `NULL` is used to indicate an unknown or missing value.

== Examples

*Creating a database*:

```sql
-- Create a database named 'contacts_db'.
create database contacts_db;
-- Create a user named 'contacts' with password 'somepassword'.
create user 'contacts'@'localhost' identified by 'somepassword';
-- Give access to the 'contacts' database to the 'contacts' user.
grant all privileges on contacts_db.* to 'contacts'@'localhost';
```

*Creating a table*:

```sql
USE contacts_db;
DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts (
  `name` VARCHAR(50), -- String of length 50.
  `surname` VARCHAR(50),
  `phone` VARCHAR(20),
  `country` VARCHAR(50),
  `age` INT,
  `signup_date` DATE,
  `status` VARCHAR(20)
);
```

*Inserting two rows*:

```sql
INSERT INTO contacts
  (`name`, `surname`, `phone`, `country`, `age`, `signup_date`, `status`)
VALUES
  ('John', 'Doe', '+1-555-0101', 'USA', 28, '2025-01-15', 'Active'),
  ('Emma', 'Smith', '+44-20-7946-0912', 'UK', 34, '2025-02-20', 'Active');
```

*Selecting rows*:

```sql
SELECT `country`
FROM contacts
WHERE `name` like 'Jo%';
```

```sql
SELECT *
FROM contacts
WHERE `age` between 30 and 40;
```
