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

```
user1>> mysql profile SELECT * FROM users
hubot>> user1:
    ┌──────────────────────────────────────┬────────────────┐
    │Status                                │Duration (secs) │
    ├──────────────────────────────────────┼────────────────┤
    │starting                              │0.000036        │
    ├──────────────────────────────────────┼────────────────┤
    │Waiting for query cache lock          │0.000004        │
    ├──────────────────────────────────────┼────────────────┤
    │checking query cache for query        │0.000042        │
    ├──────────────────────────────────────┼────────────────┤
    │checking permissions                  │0.000009        │
    ├──────────────────────────────────────┼────────────────┤
    │Opening tables                        │0.000031        │
    ├──────────────────────────────────────┼────────────────┤
    │System lock                           │0.000011        │
    ├──────────────────────────────────────┼────────────────┤
    │Waiting for query cache lock          │0.000027        │
    ├──────────────────────────────────────┼────────────────┤
    │init                                  │0.000029        │
    ├──────────────────────────────────────┼────────────────┤
    │optimizing                            │0.000006        │
    ├──────────────────────────────────────┼────────────────┤
    │statistics                            │0.000013        │
    ├──────────────────────────────────────┼────────────────┤
    │preparing                             │0.000010        │
    ├──────────────────────────────────────┼────────────────┤
    │executing                             │0.000003        │
    ├──────────────────────────────────────┼────────────────┤
    │Sending data                          │0.000089        │
    ├──────────────────────────────────────┼────────────────┤
    │end                                   │0.000006        │
    ├──────────────────────────────────────┼────────────────┤
    │query end                             │0.000006        │
    ├──────────────────────────────────────┼────────────────┤
    │closing tables                        │0.000008        │
    ├──────────────────────────────────────┼────────────────┤
    │freeing items                         │0.000007        │
    ├──────────────────────────────────────┼────────────────┤
    │Waiting for query cache lock          │0.000003        │
    ├──────────────────────────────────────┼────────────────┤
    │freeing items                         │0.000064        │
    ├──────────────────────────────────────┼────────────────┤
    │Waiting for query cache lock          │0.000008        │
    ├──────────────────────────────────────┼────────────────┤
    │freeing items                         │0.000003        │
    ├──────────────────────────────────────┼────────────────┤
    │storing result in query cache         │0.000004        │
    ├──────────────────────────────────────┼────────────────┤
    │logging slow query                    │0.000002        │
    ├──────────────────────────────────────┼────────────────┤
    │cleaning up                           │0.000003        │
    └──────────────────────────────────────┴────────────────┘

```

## Thanks

Thanks to everyone who has contributed to Hubot and this packages dependencies.

A special thank you to @technicalpickles for being awesome.