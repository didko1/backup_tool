# backup_tool
backup_tool to backup files and directories
usage:
./backup.sh dir1 dir2 ...
./backup - backup directories from .dir_backup list
options
 --add add new directories to .dir_backup list
 -a option to append file or dir to existing archive

./backup.sh -a [archive] [dir/file]

--dry-run to list all files that will be added to archive
./backup.sh dir1 --dry-run

--recover used to recover archived dirs in .dir_backup
./backup.sh --recover 
