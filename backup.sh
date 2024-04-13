#/bin/bash

export filename
export dir
export dry_run=false
export backup_file=.dir_backup
export tar=""
export append=false

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
		-a)
			shift
			append=true
			echo "append is $append"
			tar="$1"
			shift
			dir+="$1"
			dir+=" "
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
    if $append;
    then
	    tar_name=$tar
	    echo "tar is $tar_name"
    else
	    tar_name="archive_$(date +%Y%m%d%H%M).tar.xz"
    fi
    echo $tar_name
    for path in $dir;
    do
	    ls $path | while read L; do tar -rvf $tar_name $dir/$L ;done
    done
}

dryrun(){
    echo "Following files will be included to archive:"
    for path in $dir;
    do
	    ls $path
    done
}

if [[ $# -eq 0 ]];
then
	usage
else
	readArguments $@
	echo "dirs ${dir}"
	if $dry_run;
	then
		dryrun
	else
		if ! $append;
		then
			clean_backup_file
		fi
		save_dirs
		archive_dirs
	fi
fi



