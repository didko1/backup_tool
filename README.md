# backup_tool
Backup script for Linux system
Uses a hidden file '.backup_files_and_dirs' in the script directory to manage files/folders to backup

Usage: ./backup.sh [OPTIONS]

Options:
  -h, --help                 Show this help menu
  -b, --backup               Create a backup archive of files/folders listed in backup list
  -a, --add FILES_OR_DIRS    Add one or more files or directories to backup list
  -r, --remove FILES_OR_DIRS Remove one or more files or directories from backup list
  -l, --list                 List files and directories currently in backup list

Backup archive will be created in backups/ with name format: backup_YYYY-MM-DD_HH-MM-SS.tar.gz

Generate Cron Job to create backup every Friday at midnight:

$ crontab -e
0 0 * * 5 /path/to/backup.sh --backup
