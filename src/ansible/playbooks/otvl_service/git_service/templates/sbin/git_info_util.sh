#!/bin/sh

# git_info_util.sh [[git_repo] ... ]
status=0

otvl_sbin_path="{{ combined_otvl.config_paths.sbin }}"
otvl_backup_path="{{ combined_otvl.config_paths.backup }}"
project_root="{{ combined_otvl.apache.www }}/{{ combined_otvl.git_service.project_root }}"

# set up environment
. $otvl_sbin_path/otvl_sbin_lib.sh
init_env_backup $otvl_backup_path git

# callbacks and utils
. $otvl_sbin_path/otvl_git_lib.sh

do_git_info_util() {
    git_repo=$1
    echo "Bare repository ${project_root}/${git_repo}.git"
    cd ${project_root}/${git_repo}.git
    lc_git_repo=`git log --all -1 --reverse --format=format:'%ct %cd %H' --date=iso 2>&1`
    status=$?
    if [ $status -ne 0 -a "$lc_git_repo" != "fatal: your current branch 'master' does not have any commits yet" ] ; then
        fatal_error $lc_git_repo
    fi
    echo "    " $lc_git_repo
    
    object_backup_dir=$backup_dir/$git_repo
    to_be_restored=`ls ${object_backup_dir}/* 2>/dev/null | tail -1`
    echo "Last backup $to_be_restored"
    # retrieve last commit from backup bundle repo
    td1=`mktemp -d /tmp/git_XXXXXX.d`
    cd $td1 && \
        git clone --mirror $to_be_restored $td1/${git_repo}.git 2>/dev/null && \
        cd $td1/${git_repo}.git && \
        lc_to_be_restored=`git log --all -1 --reverse --format=format:'%ct %cd %H' --date=iso` || \
            status=1
    cd /tmp && rm -rf $td1
    echo "    " $lc_to_be_restored
    
    if [ "$lc_git_repo" != "$lc_to_be_restored" ] ; then
        echo "        " $git_repo "$lc_git_repo" and "$lc_to_be_restored" differ
    fi
}

if [ $# -ge 1 ] ; then
    for git_repo in $*; do
        do_git_info_util $git_repo
    done
else
    cd $project_root
    for git_repo_git in `ls -d *.git 2> /dev/null`; do
        git_repo=`basename $git_repo_git .git`
        do_git_info_util $git_repo
    done
fi
exit $status