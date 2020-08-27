#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Prod DB credentials
source $DIR/env/prod-mysql.sh

# Select target for db snapshot
case "$1" in
    "dev")
        echo "Remote shared dev environment selected as target"
        target="dev"
        source $DIR/env/dev-mysql.sh
        ;;
    "" | "local")
        echo "Local environment selected as target"
        target="local"
        dest_host="localhost"
        dest_user="tvg"
        dest_password="password"
        dest_port="8885"
        dest_database="texasvoterguide"
        ;;
    "*")
        echo "Invalid input"
        exit 1
        ;;
esac

# Warn user about data destruction 
echo "This script will download a fresh snapshot from the production database, and load it into $target."
echo "WARNING! This will delete all your test data in $target, which is kind of the point."
echo "If you didn't mean to do that, hit Ctrl+C NOW..."
sleep 10s
echo "Okay, here we go..."

# Check for MySQLDump
if ! [ -x "$(command -v mysqldump)" ]; then
    echo 'Error: mysqldump is not installed.' >&2
    exit 1
fi

# Check for MySQL Client
if ! [ -x "$(command -v mysql)" ]; then
    echo 'Error: mysql client is not installed.' >&2
    exit 1
fi

# Check production MySQL connection
if ! mysql --host=$src_host --port=$src_port --user=$src_user --password=$src_password $src_database -e ";" 2>/dev/null; then
    echo "Failed to connect to production database source.  Check config and try again."
    exit 1
fi

# Download MySQLDump from production
mysqldump --port=$src_port --host=$src_host --user=$src_user --password=$src_password --column-statistics=0 --add-drop-table $src_database 2>/dev/null > $DIR/temp/prod-dump.sql

# Check dev MySQL connection
if ! mysql --host=$dest_host --port=$dest_port --user=$dest_user --password=$dest_password $dest_database -e ";" 2>/dev/null; then
    echo "Failed to connect to target database destination ($target).  Check config and try again."
    exit 1
fi

# Push snapshot to target database, overriding previous data
mysql --host=$dest_host --port=$dest_port --user=$dest_user --password=$dest_password $dest_database < $DIR/temp/prod-dump.sql 2>/dev/null

echo "DONE!! Probably..."
