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

if [[ $# -eq 0 ]];
then
	usage
else

	readArguments $@
	echo "dirs ${dir}"
	save_dirs
fi



