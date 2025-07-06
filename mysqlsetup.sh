#!/bin/bash

DB_NAME="expensetrackerdb"
MYSQL_USER="root"
MYSQL_PASS="luck" # <-- Change this!

echo "Creating Expense Tracker database and tables..."

mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" <<EOF

CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    avatar VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    amount DOUBLE,
    category VARCHAR(30),
    date DATETIME,
    user_id INT,
    notes TEXT,
    tags VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Optional: Insert a sample user (username: test, password: test)
INSERT IGNORE INTO users (username, password, avatar) VALUES ('test', 'test', 'https://randomuser.me/api/portraits/men/32.jpg');

-- Optional: Insert a sample transaction for the test user
INSERT IGNORE INTO transactions (name, amount, category, date, user_id, notes, tags)
SELECT 'Sample Expense', -25.50, 'Food', NOW(), id, 'Lunch at cafe', 'food,lunch'
FROM users WHERE username='test' LIMIT 1;

EOF

echo "✅ MySQL setup complete!"
echo "You can now log in to MySQL and check your tables:"
echo "  mysql -u$MYSQL_USER -p$MYSQL_PASS $DB_NAME"
echo "  SHOW TABLES;"
echo "  SELECT * FROM users;"
echo "  SELECT * FROM transactions;"
