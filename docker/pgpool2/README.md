# PostgreSQL read/write splitting with PgpoolII

## setup

- copy `env-example` to `.env`
- fill the settings in `.env` accordingly, `PGPOOL_BACKEND_NOTES` follows the following format

| 0                                      | index of the primary backend node        |
| -------------------------------------- | ---------------------------------------- |
| PRIMARY_IP_ADDR                        | IP address of the primary backend node   |
| 5432                                   | port the primary backend node listens at |
| 0                                      | primary backend node weight              |
| primary                                | primary backend node name                |
| ALWAYS_PRIMARY or DISALLOW_TO_FAILOVER | primary backend node flags               |

| 1..N                 | index of the replica backend node                  |
| -------------------- | -------------------------------------------------- |
| REPLICA_IP_ADDR      | IP address of the replica backend node             |
| 5432                 | port the replica backend node node is listening at |
| 1                    | replica backend node weight                        |
| repl1 to replN       | replica backend node name                          |
| DISALLOW_TO_FAILOVER | replica backend node flags                         |

- `docker-compose up -d`
- use `psql` to test whether it can be successfully connected

## benchmark the setup

- create a `example` db
- `pgbench -i -s 50 -h localhost -p 5432 -U <USERNAME> example`
- `pgbench -s 50000 --select-only -h localhost -p 5432 -U <USERNAME> example`
- `pgbench -s 50000 --select-only -h <PRIMARY_IP_ADDR> -p 5432 -U <USERNAME> example`

## references

- https://aws.amazon.com/blogs/database/a-single-pgpool-endpoint-for-reads-and-writes-with-amazon-aurora-postgresql/
- https://www.refurbed.org/posts/load-balancing-sql-queries-using-pgpool/
