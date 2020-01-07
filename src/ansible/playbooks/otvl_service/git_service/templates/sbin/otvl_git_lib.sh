#!/bin/sh

# git_check_restore_callback object to_be_restored
git_check_restore_callback () {
    git_repo=$1
    to_be_restored=$2
    git_repo_path="${project_root}/${git_repo}.git"

    # retrieve last commit from backup bundle repo
    td1=`mktemp -d /tmp/git_XXXXXX.d`
    cd $td1 && \
        git clone --mirror $to_be_restored $td1/${git_repo}.git && \
        cd $td1/${git_repo}.git && \
        lc_to_be_restored=`git log --all -1 --reverse --format=format:'%ct %cd %H' --date=iso` || \
            status=1
    cd /tmp && rm -rf $td1
    if [ "$status" != "0" ] ; then
        exit 1
    fi
    # retrieve last commit from bare repo
    cd $git_repo_path
    lc_git_repo=`git log --all -1 --reverse --format=format:'%ct %cd %H' --date=iso 2>&1`
    status=$?
    if [ $status -ne 0 -a "$lc_git_repo" != "fatal: your current branch 'master' does not have any commits yet" ] ; then
        fatal_error $lc_git_repo
    fi
    if [ $status -ne 0 ] ; then
        # repository just created: restore is required
        echo >&2 "$to_be_restored: $lc_to_be_restored later than nothing"
        echo $to_be_restored
        return 0
    else
        if [ "$lc_to_be_restored" = "$lc_git_repo" ] ; then
            # no need to restore check is ok 
            echo >&2 "$git_repo up-to-date regarding $to_be_restored"
            return 0
        fi
        ts_to_be_restored=`echo $lc_to_be_restored | cut -d' ' -f1`
        ts_git_repo=`echo $lc_git_repo | cut -d' ' -f1`
        if [ $ts_git_repo -ge $ts_to_be_restored ] ; then
            echo >&2 "$git_repo $lc_git_repo appears later than restore point $lc_to_be_restored"
            fatal_error "please proceed manually"  
        fi   
        echo >&2 "$to_be_restored: $lc_to_be_restored later than $lc_git_repo"
        echo $to_be_restored
        return 0
    fi
}

# is_error_fatal ()
is_error_fatal () {
    if [ -z "$dont_exit" ] ; then
        fatal_error $*
    else
        echo >&2 $*
        return 1
    fi
}

# git_backup git_repo_path git_bundle_backup_path [dont_exit]
do_git_backup () {
    git_repo_path=$1
    git_bundle_backup_path=$2
    dont_exit=$3
    cd $git_repo_path
    lc_git_repo=`git log --all -1 --reverse --format=format:'%ct %cd %H' --date=iso 2>&1`
    status=$?
    if [ $status -ne 0 -a "$lc_git_repo" != "fatal: your current branch 'master' does not have any commits yet" ] ; then
        is_error_fatal $lc_git_repo
        return 1
    fi
    if [ $status -eq 0 ] ; then
        git bundle create $git_bundle_backup_path --all 2>/dev/null && \
        echo >&2 "Git repository $git_repo_path backup to $git_bundle_backup_path" || \
        status=1
        if [ $status -ne 0 ] ; then
            is_error_fatal "Git repository $git_repo_path backup to $git_bundle_backup_path failed"
            return 1
        fi
    fi
}

# do_git_restore $object $to_be_restored
do_git_restore () {
    git_repo=$1
    to_be_restored=$2
    status=0
    cd $project_root && \
        rm -rf $git_repo_path && \
        git clone --mirror $to_be_restored $git_repo_path && \
        cd $git_repo_path && \
        git config http.receivepack true && \
        cd ${project_root} && \
        chown -R ${apache_user}:${apache_group} ${git_repo}.git || \
        status=1
    if [ "$status" != "0" ] ; then
        echo >&2 "Failed to restore Git repository $git_repo_path from $to_be_restored"
        exit 1
    fi    
}
