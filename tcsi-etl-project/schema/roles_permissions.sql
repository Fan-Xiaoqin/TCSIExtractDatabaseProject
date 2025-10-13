-- Create roles
CREATE ROLE db_readonly;
CREATE ROLE db_dataentry;
CREATE ROLE db_admin;

-- Grant permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_readonly;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO db_dataentry;
GRANT ALL PRIVILEGES ON SCHEMA public TO db_admin;
