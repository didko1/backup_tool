#/bin/bash

export filename
export dir=""
export dry_run=false
export backup_file=.dir_backup
export tar=""
export append=false
export recover_backup=false

usage(){
    echo "Usage: ./backup.sh dir1 dir2 ....Provide at least one directory!"
}

show_help_message(){
    usage
    echo  "Options"
    echo "-a append file/dir to archive"
    echo "--recovery recover previous archive"
    echo "--dry-run list files that will be archived"
    echo "-h show this message"
}

readArguments(){
    while [[ $# -gt 0 ]];
    do
	case $1 in
		-n|--dry-run)
			dry_run=true
			shift
			;;
		-a)
			shift
			append=true
			tar="$1"
			shift
			dir+="$1"
			dir+=" "
			shift
			;;

		--recover)
			shift
			recover_backup=true
			;;
		-h)
			show_help_message
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

recover(){
    echo "recovering backups"
    if ! [[ -e $backup_file ]];
    then
	echo "!!! nothing to recover !!!"
	exit 1
    fi
    cat $backup_file | while read D;
    do
	echo "archiving directory $D"
        tar -rvf backup_recovered.tar.xz $D
    done
}

############# main ###########
if [[ $# -eq 0 ]];
then
	usage
else
	readArguments $@
	if $dry_run;
	then
		dryrun
	elif $recover_backup;
	then
		recover
	else
		if ! $append;
		then
			clean_backup_file
		fi
		save_dirs
		archive_dirs
	fi
fi



