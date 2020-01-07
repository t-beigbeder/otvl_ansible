
# init_env otvl_backup_path 
init_env () {
    otvl_backup_path=$1
}

# init_env_backup otvl_backup_path category
init_env_backup () {
    init_env $1
    category=$2
    backup_dir=$otvl_backup_path/$category
    restore_dir=$otvl_backup_path/$category/restore
    if [ ! -d $backup_dir ] ; then
        echo >&2 "Backup directory: $backup_dir not available"
        exit 1
    fi
}

# fatal_error
fatal_error () {
    echo >&2 $*
    exit 1
}

# check_restore procedure object
check_restore () {
    procedure=$1
    object=$2
    object_backup_dir=$backup_dir/$object
    object_restore_dir=$restore_dir/$object
    mkdir -p $object_backup_dir || fatal_error "cannot create backup $object_backup_dir"
    mkdir -p $object_restore_dir || fatal_error "cannot create backup $object_restore_dir"
    to_be_restored=`ls ${object_backup_dir}/* 2>/dev/null | tail -1`
    if [ -z "$to_be_restored" -o ! -f $to_be_restored ] ; then
        echo >&2 "nothing to restore in $category for $object"
        return 0
    fi
    last_restore=`cat $object_restore_dir/last_restore.txt 2>/dev/null`
    if [ "$last_restore" = "$to_be_restored" ] ; then
        echo >&2 "restore in $category for $object already done or no change since backup"
        return 0
    fi
    if [ "$procedure" ] ; then
        to_be_restored=`$procedure $object $to_be_restored`
        if [ $? -ne 0 ] ; then
            fatal_error "check restore in $category for $object failed"
        fi
    fi
    echo $to_be_restored
    return 0
}

# do_restore procedure object to_be_restored
do_restore () {
    procedure=$1
    object=$2
    to_be_restored=$3
    object_restore_dir=$restore_dir/$object
    if [ "$procedure" ] ; then
        $procedure $object $to_be_restored
        if [ $? -ne 0 ] ; then
            fatal_error "perform restore in $category for $object from $to_be_restored failed"
        fi
    fi
    echo $to_be_restored > $object_restore_dir/last_restore.txt
}

# do_cleanup_after_backup object_backup_dir max_bundles
do_cleanup_after_backup () {
    object_backup_dir=$1
    max_bundles=$2
    nb_backup=`ls ${object_backup_dir}/* 2>/dev/null | wc -l`
    while [ $nb_backup -gt $max_bundles ] ; do
        to_be_removed=`ls ${object_backup_dir}/* 2>/dev/null | head -1`
        check_rm=`echo $to_be_removed | grep "^$otvl_backup_path/"`
        if [ "$check_rm" != "" ] ; then
            echo >&2 "rm $to_be_removed"
            rm $to_be_removed
        fi
        nb_backup=`expr $nb_backup - 1`
    done
}