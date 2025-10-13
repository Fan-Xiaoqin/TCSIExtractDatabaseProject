## Roles and Permissions Setup Guide

### 1. Purpose of Roles and Permissions

The requirement is:
> "Define user roles and access permissions to protect sensitive student data and ensure only authorized personnel can view or modify specific tables."

This is achieved through Role-Based Access Control (RBAC) in PostgreSQL:
- Roles define a set of permissions (e.g., read-only, data entry, admin).
- Users are actual database accounts that log in.
- Users inherit permissions by being assigned to roles.

This separation makes permission management secure, scalable, and consistent across environments.

### 2. Predefined Roles

A modular SQL script (`roles_permissions.sql`) defines the main database roles and grants appropriate permissions.

```sql
-- Create roles
CREATE ROLE db_readonly;
CREATE ROLE db_dataentry;
CREATE ROLE db_admin;

-- Grant permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_readonly;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO db_dataentry;
GRANT ALL PRIVILEGES ON SCHEMA public TO db_admin;
```

| Role             | Permissions Granted                   | Typical Use Case                    |
| ---------------- | ------------------------------------- | ----------------------------------- |
| **db_readonly**  | `SELECT` (read only) on all tables    | Analysts, auditors                  |
| **db_dataentry** | `SELECT, INSERT, UPDATE`              | Staff who input and correct records |
| **db_admin**     | `ALL PRIVILEGES` on schema and tables | Database administrators             |

>**Note:** DELETE, DROP and ALTER are not granted to db_readonly or db_dataentry roles to protect data integrity.

Before creating users, you must run the script that defines the roles and grants their permissions:
- **Oprion 1 - Call `roles_permission.sql` inside `init.sql`**
    ``` sql
    -- Include role creation and permissions
    \i roles_permissions.sql
    ```
    This will execute the role creation and grants as part of the database initialization.

- **Option 2 – Run the script directly**
    ```bash
    psql -U postgres -d tcsi_db -f schema/roles_permissions.sql
    ```


### 3. Creating Users and Assigning Roles

We do not hardcode users into the scripts (since usernames/passwords are environment-specific). Instead, admins could create users as needed and assign them to the predefined roles. 

Example setup:

```sql
-- Create a user for a data entry staff member
CREATE USER alice WITH PASSWORD 'strongpassword';
GRANT db_dataentry TO alice;

-- Create a read-only user
CREATE USER bob WITH PASSWORD 'anotherpassword';
GRANT db_readonly TO bob;

-- Create an admin user
CREATE USER admin_user WITH PASSWORD 'adminpassword';
GRANT db_admin TO admin_user;
```
This ensures that:
- Only authorized users can modify student data.
- Read-only users cannot alter or delete records.
- Admins retain full database control for maintenance.

### 4. Executing the Scripts

**Option 1 - Run in psql**  

If you’re using the PostgreSQL command-line interface:
```bash
psql -U postgres -d tcsi_db
```
Once inside the prompt (tcsi_db=#), run your SQL commands:

```sql
-- Create users and assign roles
CREATE USER alice WITH PASSWORD 'strongpassword';
GRANT db_dataentry TO alice;

CREATE USER bob WITH PASSWORD 'anotherpassword';
GRANT db_readonly TO bob;

CREATE USER admin_user WITH PASSWORD 'adminpassword';
GRANT db_admin TO admin_user;
```
*Best for local or server environments where you have superuser (postgres) access.*

**Option 2 – Run via SQL Script File**

Customize and execute `create_users.sql` script which is located inside schema folder:
```bash
psql -U postgres -d tcsi_db -f schema/create_users.sql
```

**Option 3 – Run from a GUI Tool (pgAdmin)**

- Open pgAdmin.
- Connect to your server.
- Open the Query Tool.
- Paste the same SQL commands.
- Click Execute.

*Easiest if you prefer a graphical interface.*

**Notes**
- You must run these commands as a superuser or admin (typically the postgres user).
- Replace passwords with secure, strong values.
- These users will automatically inherit the permissions granted to their assigned roles (db_readonly, db_dataentry, db_admin).

### 5. Verifying Users and Role Permissions
After creating users and assigning roles, you can verify them using either psql shortcuts or SQL queries.

**Option 1 – Using \du in psql**
```sql
\du
```
This displays all roles and users, their attributes, and membership. Example output:
| Role name    | Attributes                         | Member of      |
|-------------|-----------------------------------|----------------|
| postgres     | Superuser, Create role, Create DB | {}             |
| db_readonly  | Cannot login                       | {}             |
| db_dataentry | Cannot login                       | {}             |
| db_admin     | Cannot login                       | {}             |
| alice        |                                   | {db_dataentry} |
| bob          |                                   | {db_readonly}  |
| admin_user   |                                   | {db_admin}     |


**Option 2 – Check via system catalogs**
- List roles
    ```sql
    SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin
    FROM pg_roles;
    ```

**Option 3 – Test login and access**  
- Log in as each user to ensure permissions are working as intended:
    ```bash
    psql -U alice -d tcsi_db
    ```

- Try reading data:
    ```sql
    SELECT * FROM hep_students LIMIT 5;
    ```

- Attempt restricted operations (like DELETE) to confirm access control works:
    ```sql
    DELETE FROM hep_students WHERE student_id = 1;
    -- Should return: ERROR: permission denied
    ```
>Tip: Always test at least one user from each role (read-only, data entry, admin) to ensure RBAC is enforced correctly.

### 6. Future Enhancements
- Implement table-specific restrictions (e.g., hide sensitive columns from read-only users).
- Enforce row-level security (RLS) for student data if required.
- Integrate with LDAP or external authentication for enterprise environments.

---

**Document Version:** 1.0  
**Prepared by:** *Group 3 – CITS5206 2025 Semester 2*  
**Date:** *October 2025*
