#!/usr/bin/env sh

# shellcheck source=../../../scripts/create_table.sh
. "$(dirname "$0")"/../../../scripts/create_table.sh
# shellcheck source=../../../scripts/insert.sh
. "$(dirname "$0")"/../../../scripts/insert.sh

DB_PATH="$1"
shift

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
			insert "$DB_PATH" "$PAGE_NAME" "$PAGE_TYPE" "$(basename "$1")"
		fi
		shift
	done
}

create_table "$DB_PATH"
insert_pages "$@"
