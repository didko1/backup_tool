#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_LIST="$SCRIPT_DIR/.backup_files_and_dirs"
BACKUP_DIR="$SCRIPT_DIR/backups"

mkdir -p "$BACKUP_DIR"

show_help() {
	cat << EOF
Usage: $0 [OPTIONS]

Options:
  -h, --help                 Show this help menu
  -b, --backup               Create a backup archive of files/folders listed in $BACKUP_LIST
  -a, --add FILES_OR_DIRS    Add one or more files or directories to $BACKUP_LIST
  -r, --remove FILES_OR_DIRS Remove one or more files or directories from $BACKUP_LIST
  -l, --list                 List files and directories currently in $BACKUP_LIST

Backup archive will be created in '$BACKUP_DIR' with name format: backup_YYYY-MM-DD_HH-MM-SS.tar.gz
EOF
}

create_backup() {
	if [[ ! -f "$BACKUP_LIST" ]] || [[ ! -s "$BACKUP_LIST" ]]; then
		echo "No files or directories listed in $BACKUP_LIST"
		exit 1
	fi
	TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
	BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
	tar -czf "$BACKUP_FILE" -T "$BACKUP_LIST" 2>/dev/null
	if [[ $? -eq 0 ]]; then
		echo "Backup created successfully $BACKUP_FILE"
	else
		echo "ERROR: Some files cannot be backed up"
	fi
}

add_entries() {
	if [[ $# -eq 0 ]]; then
                echo "No files or directories specified to add"
                exit 1
        fi
	for FILE in "$@"; do
		if grep Fxq "$FILE" "$BACKUP_LIST" 2>/dev/null; then
			echo "$FILE already in backup list"
		else
			echo "$FILE" >> "$BACKUP_LIST"
			echo "$FILE added to backup list"
		fi
	done
}

remove_entries() {
	if [[ $# -eq 0 ]]; then
                echo "No files or directories specified to remove"
                exit 1
        fi
	for FILE in "$@"; do
		if grep -Fxq "$FILE" "$BACKUP_LIST"; then
			grep -Fxv "$FILE" "$BACKUP_LIST" > "$BACKUP_LIST.temp" && mv "$BACKUP_LIST.temp" "$BACKUP_LIST"
			echo "$FILE removed from backup list"
		else
			echo "$FILE is not in backup list"
		fi
	done
}

list_entries() {
	if [[ ! -f "$BACKUP_LIST" ]] || [[ ! -s "$BACKUP_LIST" ]]; then
		echo "Backup list is empty."
	else
		echo "Files and directories in backup list:"
		cat "$BACKUP_LIST"
    	fi

}

while [[ $# -gt 0 ]];do
	case $1 in
		-h|--help)
			show_help
			exit 0;
			;;
		-b|--backup)
			create_backup
			exit 0;
			;;
		-a|--add)
			shift
			add_entries "$@"
			exit 0;
			;;
		-r|--remove)
			shift
			remove_entries "$@"
			exit 0;
			;;
		-l|--list)
			list_entries
			exit 0;
			;;
		*)
			echo "Unknown option: $1"
			show_help
			exit 1;
			;;
	esac
done
#if no arguments provided
show_help
