CREATE USER alice WITH PASSWORD 'strongpassword';
GRANT db_dataentry TO alice;

CREATE USER bob WITH PASSWORD 'anotherpassword';
GRANT db_readonly TO bob;

CREATE USER admin_user WITH PASSWORD 'adminpassword';
GRANT db_admin TO admin_user;