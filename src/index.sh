#!/usr/bin/env sh

create_table() {
	sqlite3 "$DB_PATH" "CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
	sqlite3 "$DB_PATH" "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"
}

get_title() {
	FILE="$1"

	pup -p -f "$FILE" 'title text{}' | \
		sed 's/(Autoconf Archive)//g' | \
		sed 's/\"/\"\"/g'
}

get_type() {
	FILE="$(basename "$1")"
	MACRO_PATTERN="^ax_"

	if echo "$FILE" | grep -q "$MACRO_PATTERN"; then
		echo "Macro"
	fi
}

insert() {
	NAME="$1"
	TYPE="$2"
	PAGE_PATH="$3"

	sqlite3 "$DB_PATH" "INSERT INTO searchIndex(name, type, path) VALUES (\"$NAME\",\"$TYPE\",\"$PAGE_PATH\");"
}

insert_pages() {
	# Get title and insert into table for each html file
	while [ -n "$1" ]; do
		unset PAGE_NAME
		unset PAGE_TYPE
		PAGE_NAME="$(get_title "$1")"
		if [ -n "$PAGE_NAME" ]; then
			PAGE_TYPE="$(get_type "$1")"
			#get_type "$1"
			if [ -z "$PAGE_TYPE" ]; then
				PAGE_TYPE="Guide"
			fi
			#echo "$PAGE_TYPE"
			insert "$PAGE_NAME" "$PAGE_TYPE" "$(basename "$1")"
		fi
		shift
	done
}

DB_PATH="$1"
shift

create_table
insert_pages "$@"
