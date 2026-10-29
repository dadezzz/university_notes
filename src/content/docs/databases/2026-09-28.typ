#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Superkeys, candidate keys, and referential integrity, followed by relational algebra operators such as select, project, join, intersection, and set difference.",
  lang: "en",
  title: "Primary keys, foreign keys and relational algebra",
))

= Primary keys

Let $A_1, ..., A_n$ be the attributes of a table and $R = (A_1, ..., A_n)$ be
the relation schema of the table. A relation instance $r$ defined over schema
$R$ is denoted by $r(R)$.

$K$ is a superkey of $R$ if values for $K$ are sufficient to uniquely identify a
tuple in each possible $r(R)$. Each superset of $K$ is also a superkey; if $K$
is minimal (no subset is a superkey) then $K$ is a *candidate key*.

One of the candidate keys can be selected as the *primary key* for the table. A
primary key of a table should be chosen so that its attribute values rarely or
never change.

= Foreign keys

Rows in a certain table can refer to rows in other tables through foreign key
constraints.

A foreign key constraint from attribute $A$ of $r_1$ to key $B$ of $r_2$ states
that, on any instance, the value of $A$ in each tuple of $r_1$ must also appear
as the value of $B$ in some tuple of $r_2$. Every foreign key must reference a
candidate key of $r_2$, usually the primary key.

Referential integrity is the rule that every non-null reference in a relation
must match a key value in the referenced relation.

= Relational algebra

Relational algebra is a set of operations used to query and manipulate data in
relational databases. Operations on the database can be *queries* (they read
data) or *updates* (they change data). Both can be modeled as functions from
databases to databases.

A procedural language consists of a set of operations that take one or two
relations as input and produce a new relation as their result. Expressions can
be combined to form more complex ones.

There are some basic operators:

- *Select ($sigma_(p)(r)$)*: selects tuples that satisfy a given predicate.

  $p$ is called the selection predicate and it supports comparisons between
  attributes or between an attribute and a scalar using $=$, $!=$, $>$, $>=$,
  $<$, $<=$. Several predicates can be combined using the connectives $and$,
  $or$, $not$.

  Properties:

  - it produces a relation that has the same schema as $r$;
  - it is commutative, so the order of application doesn't matter;
  - a sequence of selection operations can be replaced by a single operation
    using the connective $and$;
  - the number of tuples returned is at most the number of tuples of $r$;

- *Project ($product_(A_1, A_2, ..., A_K)(r)$)*: returns its argument relation
  with certain attributes left out.

  Duplicate rows (e.g., when a distinguishing attribute is left out) are removed
  from the result since relations are sets, so the result contains at most as
  many tuples as the operand.

  The project operation is not commutative.

- *Cartesian product ($r_1 times r_2$)*: allows combining information from any
  two relations. It constructs result tuples from all possible combinations of
  the operands' tuples.

  The *join operation* is defined as the combination of a select and a cartesian
  product. Given $r_1(A_1, A_2)$ and $r_2(B_1, B_2)$ the join
  $r_1 bowtie.stroked.big_(A_1 = B_1) r_2 = sigma_(A_1 = B_1) (r_1 times r_2)$
  returns the combination of rows of $r_1$ and $r_2$ whose attributes match.

Since relations are sets we can also apply set operators. However we want the
results to be relations, therefore we can only apply these to pairs of relations
defined over the same set of attributes.

- *Union ($union$)*: allows combining two relations into one.
- *Intersection ($inter$)*: allows finding tuples that are present in both input
  relations.
- *Set difference ($without$)*: allows finding tuples that are in one relation
  but not in the other.

Union and intersection are commutative and associative.

Two other convenient operations are:

- *Assignment ($x arrow.l "op"$)*: assigns the result of $"op"$ to $x$. Used to
  create temporary relation variables. Works like assignment in programming
  languages.
- *Rename ($rho_x(E)$)*: renames the relation $E$ to $x$. The difference from
  assignment is that rename doesn't create another separate relation. Useful to
  avoid naming conflicts in joins.


