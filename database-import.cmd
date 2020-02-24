psql -U postgres -c "DROP SCHEMA public CASCADE;"
psql -U postgres -c "CREATE SCHEMA public;"
psql -U postgres -f %1