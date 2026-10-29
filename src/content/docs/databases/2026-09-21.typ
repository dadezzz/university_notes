#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Database system purpose, data models, abstraction levels, database languages (DDL and DML), the query processor, storage manager and transaction handling.",
  lang: "en",
  title: "Database system architecture and data models",
))

= Databases

A database system is a collection of interrelated data and a set of programs
that allow users to access and modify the data. Its major purpose is to provide
an abstract view of the data, hiding how it is stored and maintained.

== Data models

A data model is used to describe the data, its relationships, semantics and
consistency constraints.

- *relational*: uses a collection of tables to represent both data and the
  relationships among the data;
- *object-based*: merges programming language objects with databases;
- *semi-structured*: based on flexible JSON or XML schemas;

== Levels of abstractions

- *physical level*: describes how a record is stored on the filesystem;
- *logical level*: describes what data is stored in the database and the
  relationships among that data, using a small number of data structures;
- *view level*: describes what users can see and what they cannot, depending on
  security restrictions;

== Database languages

When talking about database languages we distinguish two domains:

- Data definition languages (DDL): used to specify the database schema.

  The stored data must satisfy certain constraints, which can be defined with
  the DDL:

  - domain constraints: e.g., the number of invoices in a certain month cannot
    be negative;
  - referential integrity: a value that appears in a row of a relation must also
    appear in the referenced relation;
  - authorization: defines the set of operations that different users can
    execute on the data;

- Data manipulation languages (DML): used to express database queries and
  updates.

  There are two kinds of DML:

  - procedural DML: specifies what data is needed and how to get it;
  - declarative DML: specifies what data is needed but leaves the decision of
    how to get it to the DBMS;

In practice, the most commonly used language (*SQL*) covers both. SQL is a
declarative query language that can take several tables as input and always
returns one output table of data.

== Database systems

A database system is partitioned into modules that deal with each of the
responsibilities of the overall system.

The two main components are:

- *Query processor*: handles each query and the interaction with the client:

  + parses the query, checking for syntax and relation names, translates to
    relational algebra;
  + optimizes the query, picking the lowest cost plan among the various
    alternatives (e.g., if there are multiple indexes);
  + generates low-level instructions for the storage manager;

- *Storage manager*: low-level interface between the stored data and the query
  processor; it manages:

  - interactions with the OS filesystem;
  - transaction consistency;
  - buffers and caches;
  - authorization enforcement;

== Transactions

A transaction is a collection of operations that performs a single logical
function in a database application. Transactions must be able to handle:

- *Concurrency*: what happens if a user starts a transaction to edit multiple
  rows, but another user modifies the same row in between? There will be the
  need to handle conflicts.
- *Failure recovery*: what happens if the database, the connection or the
  application fail in the middle of the transaction? Data needs to be rolled
  back to a safe state.

