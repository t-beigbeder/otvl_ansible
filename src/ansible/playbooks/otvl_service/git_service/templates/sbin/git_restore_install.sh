#!/bin/sh
# git_restore_install.sh [--check] <project_root> <git_repo> <apache_user> <apache_group> <otvl_backup_path>
otvl_sbin_path="{{ combined_otvl.config_paths.sbin }}"
status=0

if [ "$1" = "--check" ] ; then
    check=1
    shift
else
    check=
fi
project_root=$1
shift
git_repo=$1
shift
apache_user=$1
shift
apache_group=$1
shift
otvl_backup_path=$1
shift
if [ -z "$project_root" ] ; then
    echo >&2 project_root must be set
    exit 1
fi
if [ -z "$git_repo" ] ; then
    echo >&2 git_repo must be set
    exit 1
fi

# set up environment
. $otvl_sbin_path/otvl_sbin_lib.sh
init_env_backup $otvl_backup_path git
git_repo_path="${project_root}/${git_repo}.git"

# callbacks and utils
. $otvl_sbin_path/otvl_git_lib.sh

# check first
to_be_restored=`check_restore git_check_restore_callback $git_repo`
if [ -z "$to_be_restored" ] ; then
    if [ "$check" ] ; then
        exit 0
    else
        fatal_error "restore in $category for $object is not authorized"
    fi
fi
if [ "$check" ] ; then
    echo $to_be_restored
    exit 0
fi

# Perform a backup 
object_restore_dir=$restore_dir/$git_repo
cur_dt=`date +%Y%m%d-%H%M%S`
do_git_backup $git_repo_path $object_restore_dir/${git_repo}.bundle_before_restore.${cur_dt}

# Restore from latest backup
do_restore do_git_restore $git_repo $to_be_restored
echo >&2 "$git_repo has been restored from $to_be_restored"
exit 0
