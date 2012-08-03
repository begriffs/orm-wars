# ORM Wars

Testing various ORMs with more complicated (realistic) situations.
I want to see which queries are possible within each library, and
what SQL it generates.

## Experiments include

Queries
* Joins
* Subqueries / EXISTS
* Window functions
* Grouping / having
* Distinct
* IN (a, b, c)
* Geospatial
* Transactions

Indexing
* Creating b-tree / hash
* Multicolumn
* Functional
* cluster on

Constraints
* Foreign keys
* on delete … no action / cascade / restrict
