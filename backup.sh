#/bin/bash

export filename
export dir
export dry_run=false

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

save_dirs(){
   delim=" "
   read -ra newarr <<< "$dir"
   for val in "${newarr[@]}";
   do
           echo "$val" >> .dir_backup
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
	save_dirs
	archive_dirs
fi



