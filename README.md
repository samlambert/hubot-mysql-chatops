# Hubot: hubot-mysql-chatops

A small collection of MySQL ChatOps scripts.

See each script in `src/` for full documentation.

## Installation

Add **hubot-mysql-chatops** to your `package.json` file:

```json
"dependencies": {
  "hubot-mysql-chatops": ">= 1.0.0",
}
```

Add **hubot-mysql-chatops** to your `external-scripts.json`:

```json
["hubot-mysql-chatops"]
```

Run `npm install`

## Warnings

Some of these scripts execute queries. It is very strongly recommended that a read only user is used and queries are executed on a MySQL slave.

I can't be responsible for you deleting all your data ;)

An example GRANT would be: `GRANT SELECT ON some_db.* TO 'hubot_mysql'@'hubot_host' IDENTIFIED BY 'some_pass';`

## Sample Interaction

```
user1>> mysql explain SELECT * FROM users
hubot>> user1:
		┌───────────────┬─────────┬──────────┬────────┬────────┬──────────┬────────┬──────────┬────┐
		│Select Type    │Table    │Type      │Possibl…│Key     │Key Len   │Ref     │Rows      │Ext…│
		├───────────────┼─────────┼──────────┼────────┼────────┼──────────┼────────┼──────────┼────┤
		│SIMPLE         │users    │ALL       │null    │null    │null      │null    │0         │    │
		└───────────────┴─────────┴──────────┴────────┴────────┴──────────┴────────┴──────────┴────┘
```

## Thanks

Thanks to everyone who has contributed to Hubot and this packages dependencies.

A special thank you to @technicalpickles for being awesome.