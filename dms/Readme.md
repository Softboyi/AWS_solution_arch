## Launch a MySQL RDS instance (Source DB)
```sh
aws rds create-db-instance \
    --db-instance-identifier source-mysql \
    --db-instance-class db.t4g.micro \
    --engine mysql \
    --engine-version 8.0.40 \
    --master-username admin \
    --master-user-password Password123! \
    --no-multi-az \
    --allocated-storage 20 \
    --publicly-accessible \
```

## Create a PostgreSQL RDS instance (Target DB)
```sh
aws rds create-db-instance \
    --db-instance-identifier target-postgres \
    --db-instance-class db.t4g.micro \
    --engine postgres \
    --engine-version 17.2 \
    --master-username postgres \
    --master-user-password Password123! \
    --db-name postgresdb \
    --no-multi-az \
    --allocated-storage 20 \
    --publicly-accessible 
```
## Insert sample data into MySQL

```sh
mysql -u admin -p < employees_setup.sql
```

## Create a DMS replication instance
```sh
aws dms create-replication-instance \
    --replication-instance-identifier dms-repl-instance \
    --replication-instance-class dms.t3.micro \
    --allocated-storage 20 \
    --no-multi-az \
    --publicly-accessible \
    --network-type ipv4
```
## Create source endpoint [MySQL] in DMS
```sh
aws dms create-endpoint \
    --endpoint-type source \
    --engine-name MySQL \
    --endpoint-identifier src-endpoint \
    --username admin\
    --password Password123! \
    --server-name \
    --port 3306
```
## Create target endpoint [Postgres] in DMS

```sh
aws dms create-endpoint \
    --endpoint-type target \
    --engine-name Postgres \
    --endpoint-identifier target-endpoint \
    --username postgres\
    --password Password123! \
    --server-name  \
    --port 5432 \
    --database-name postgres-db\
    --ssl-mode require
```

## Create a migration task

```sh
aws dms create-replication-task \
  --replication-task-identifier migrate-mysql-to-postgres \
  --source-endpoint-arn $src_arn \
  --target-endpoint-arn $target_arn \
  --replication-instance-arn $instance_arn \
  --migration-type full-load \
  --table-mappings file://table-mappings.json
```

## Determine Available Individual Assessments:
```sh
aws dms describe-applicable-individual-assessments \
--replication-task-arn $task_arn
```


## Start the Premigration Assessment Run:

```sh
aws dms start-replication-task-assessment-run \
  --replication-task-arn $task_arn \
  --service-access-role-arn arn:aws:iam::861276117245:role/dms-vpc-role \
  --result-location-bucket $bucket \
  --assessment-run-name migration-assessment
```

## Monitor the Assessment progress and review the results:​
```sh
aws dms describe-replication-task-assessment-runs \
--filters Name=replication-task-arn,Values=$task_arn
```

## Run the task and verify data in PostgreSQL

```sh
aws dms start-replication-task
--replication-task-arn $task_arn \
--start-replication-task-type start-replication
```

## Clean up resources to avoid charges :)

```sh
#Delete the DMS Replication Task 
aws dms delete-replication-task --replication-task-arn $task_arn

 #Delete the DMS Replication Instance
aws dms delete-replication-instance --replication-instance-arn $instance_arn

 #Delete the DMS Endpoints
aws dms delete-endpoint --endpoint-arn $src_arn

aws dms delete-endpoint --endpoint-arn $target_arn

 # Delete the RDS Instances
aws rds delete-db-instance --db-instance-identifier source-mysql --skip-final-snapshot --delete-automated-backups

aws rds delete-db-instance --db-instance-identifier target-postgres --skip-final-snapshot --delete-automated-backups

 #Delete the S3 Bucket (Used for the Assessment Reports)

aws s3 rm s3://$bucket --recursive

aws s3api delete-bucket --bucket $bucket
```