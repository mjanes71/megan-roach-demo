# Multi Node Roach Demo
The purpose of this demo is to showcase some of the features of self-hosting a multi-node cockroach cluster that have been useful to me. If you're looking to learn about Cockroachdb, the [Cockroachdb Docs](https://www.cockroachlabs.com/docs/) are usually very helpful.

## High Availability with a multi-node cluster

### Start three individual cockroach nodes :battery:
```
cockroach start --insecure --store=node1 --listen-addr=localhost:26257 --http-addr=localhost:8080 --join=localhost:26257,localhost:26258,localhost:26259
```

```
cockroach start --insecure --store=node2 --listen-addr=localhost:26258 --http-addr=localhost:8081 --join=localhost:26257,localhost:26258,localhost:26259
```

```
cockroach start --insecure --store=node3 --listen-addr=localhost:26259 --http-addr=localhost:8082 --join=localhost:26257,localhost:26258,localhost:26259

```
Get all those nodes connected to initialize a cluster
```
cockroach init --insecure --host=localhost:26257
```

### Check out your 3 node cluster in the dashboard :eyes:
```
http://localhost:8080
```
:zap: *If doing a live demo, this is a really good place to pause and explain what a cockroach cluster is and how that relates to a k8s cluster*

### Create a database with a table and a few records :page_facing_up:
```
cockroach sql --url 'postgresql://root@localhost:26257/defaultdb?sslmode=disable'
```
```
show databases;
create database i_will_survive;
show databases;
```
```
set database=i_will_survive;
show tables;

create table gloria (
    id uuid default gen_random_uuid(), 
    songs string, 
    constraint "primary" PRIMARY KEY (id)
    );

show tables;
```

```
show create gloria;

insert into gloria (songs) values 
('First Be a Woman'), 
('I Will Survive'), 
('I Am What I Am');

select * from gloria;

```
:zap: *If doing a live demo, this is a good time to pause and show the databases tab in the gui to demonstrate that data is replicated across all 3 nodes. Also a good time to pull up the replication dashboard and talk about data replication defaults*

check out the replication for a single row

```
show range from index gloria@primary for row ('');
```

### Start 2 more nodes :battery:
```
cockroach start --insecure --store=node4 --listen-addr=localhost:26260 --http-addr=localhost:8083 --join=localhost:26257,localhost:26258,localhost:26259
```

```
cockroach start --insecure --store=node5 --listen-addr=localhost:26261 --http-addr=localhost:8084 --join=localhost:26257,localhost:26258,localhost:26259
```

:zap: *If doing a live demo, check out the replication dashboard to show how data is being automagically redistributed*

Once re-distribution is complete, let's check on that same row to see where it ended up having replicas
```
show range from index gloria@primary for row ('');
```

:zap: *If live demoing and you have clusters that you're managing out in the wild, consider showing a stage or prod dashboard where this redistribution has happened in real life due to node deaths*

### Let's take a backup of our database :outbox_tray:
```
backup database i_will_survive into 'nodelocal://1/backups/iwillsurvive_backup';

SHOW BACKUPS IN 'nodelocal://1/backups/iwillsurvive_backup';
```
:zap: *If live-demoing, might be cool to show where this backup went and compare that to how you might do this out in the wild on real clusters*

### Now let's restore that database to a new replica database on our same cluster :inbox_tray:
```
RESTORE DATABASE i_will_survive FROM latest IN 'nodelocal://1/backups/iwillsurvive_backup' with new_db_name='i_did_survive';

set database=i_did_survive;

show tables;

select * from gloria;
```

### Squash the Roach :fire:
Now just for fun, before we tear everything down, let's kill one of the nodes with a ctrl+c in the term window running it. Check out the overview dashboard and watch it go from "suspect" to "dead". When that happens, we should start to see underreplicated ranges start to go down as re-replication and distribution happens. But it will stop at some point because when we scaled our cluster up to 5 nodes, the underlying systems tables increased their replication factor from 3 to 5. To bring the replication factor back down, let's decommission the dead node.
```
cockroach node decommission 5 --insecure
```

### Cleanup :wrench:
To cleanup, ctrl+c all other term windows that are running nodes or find the processes and kill them
```
ps -ef | grep cockroach | grep -v grep

kill -TERM ####
```

Then remove the node dirs from your machine
```
rm -rf node1 node2 node3 node4 node5```