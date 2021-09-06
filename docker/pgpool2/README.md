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

## parameters explained

- `PGPOOL_ENABLE_LOAD_BALANCING=yes`: we want to load balance the select statements by weight
- `PGPOOL_ENABLE_STATEMENT_LOAD_BALANCING=yes`: we don't want session level (per connection) load balancing
- `PGPOOL_MAX_POOL=4`: number of connections in each child process
- `PGPOOL_NUM_INIT_CHILDREN=32`: number of preforked server process
- `PGPOOL_MAX_POOL` x `PGPOOL_NUM_INIT_CHILDREN`: number of connections to a single backend node
- `PGPOOL_ENABLE_LOG_PER_NODE_STATEMENT=no`: turn to `yes` when you want to debug

## benchmark the setup

- create a `example` db
- `pgbench -i -s 50 -h localhost -p 5432 -U <USERNAME> example`
- `pgbench -s 50000 --select-only -h localhost -p 5432 -U <USERNAME> example`
- `pgbench -s 50000 --select-only -h <PRIMARY_IP_ADDR> -p 5432 -U <USERNAME> example`

or

- `pgbench -n -f <(echo 'select * from <TABLE> limit 10000') -c10 -T30 -P5 -h <HOST> -U <USER> <DB>`
- `pgbench -n -f <(echo 'select count(*) from <TABLE>') -c10 -T30 -P5 -h <HOST> -U <USER> <DB>`
- `pgbench -n -f test.sql -s10 -j10 -c10 -T30 -P5 -h <HOST> -U <USER> <DB>`
- `-s`: scaling factor, the volume of data created
- `-j`: threads, for multi-core cpu

NOTE: pgbench has a overhead to do load balancing, however, it will improve performance on heavy queries by distributing the load to different backends

## references

- https://aws.amazon.com/blogs/database/a-single-pgpool-endpoint-for-reads-and-writes-with-amazon-aurora-postgresql/
- https://www.refurbed.org/posts/load-balancing-sql-queries-using-pgpool/
- https://www.postgresql.org/message-id/002d01d283b0%245c879d80%241596d880%24%40gmail.com
- https://www.highgo.ca/2019/09/06/can-you-gain-performance-with-pgpool-ii-as-a-load-balancer/
