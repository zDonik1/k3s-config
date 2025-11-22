# PostgreSQL

All services requiring Postgres will have a separate user and database. Her are the set up instructions to bootstrap such services.

Connect to it with the admin credentials and run the following commands to set up the database and user:

```sql
CREATE USER <username> WITH PASSWORD '<password>';
CREATE DATABASE <database> OWNER <username>;
```
