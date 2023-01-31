
CREATE user :username with nosuperuser encrypted password 'dummy_password'; -- change password securely later

GRANT CONNECT ON DATABASE :dbname TO :username;

GRANT USAGE, CREATE ON SCHEMA :schemaname TO :username;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA :schemaname TO :username;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA :schemaname TO :username;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA :schemaname TO :username;
ALTER DEFAULT PRIVILEGES IN SCHEMA :schemaname GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO :username;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO :username ;
GRANT SELECT ON ALL TABLES IN SCHEMA :schemaname TO :username ;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO :username;
ALTER DEFAULT PRIVILEGES IN SCHEMA :schemaname GRANT SELECT ON TABLES TO :username;

