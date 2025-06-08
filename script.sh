#!/bin/bash

echo " Setting up Book catalog......"

# Create database 
psql -U postgres -h localhost -c "CREATE DATABASE book_catalog;"

# Runmigration
psql -U postgres -h localhost -d book_catalog -f src/database/migrations/001_initial_schema.sql

# Create stored procedures
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_create_book.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_get_books.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_delete_book.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_update_book.sql



echo "Database setup complete....."

echo "You can now run : npm run start:dev"