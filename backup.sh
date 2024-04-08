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

if [[ $# -eq 0 ]];
then
	usage
else

	readArguments $@
	echo "dirs ${dir}"
fi



