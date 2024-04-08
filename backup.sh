#/bin/bash

export filename
export dir
export dry_run=false
export backup_file=.dir_backup

usage(){
   echo "Usage: ./backup.sh dir1 dir2 ....Provide at least one directory!"
}

show_help_message(){
   echo  "Use  "
}

readArguments(){
    while [[ $# -gt 0 ]];do
	case $1 in
		-n|--dry-run)
			dry_run=true
			echo "dry_run $dry_run"
			shift
			;;
		*)
			dir+="$1"
			dir+=" "
			shift
			;;
	esac
    done
}

clean_backup_file(){
    echo "directories backed up" > $backup_file
}

save_dirs(){
   delim=" "
   read -ra newarr <<< "$dir"
   for val in "${newarr[@]}";
   do
           echo "$val" >> $backup_file
   done

}

archive_dirs(){
    tar_name="archive_$(date +%Y%m%d).tar.xz"
    echo $tar_name
    for path in $dir;
    do
	    ls $path | while read L; do tar -rvf $tar_name $dir/$L ;done
    done
}


if [[ $# -eq 0 ]];
then
	usage
else
	readArguments $@
	echo "dirs ${dir}"
	clean_backup_file
	save_dirs
	archive_dirs
fi



