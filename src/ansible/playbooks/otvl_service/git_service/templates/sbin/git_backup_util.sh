#!/bin/sh

# git_backup_util.sh
status=0

otvl_sbin_path="{{ combined_otvl.config_paths.sbin }}"
otvl_backup_path="{{ combined_otvl.config_paths.backup }}"
project_root="{{ combined_otvl.apache.www }}/{{ combined_otvl.git_service.project_root }}"
git_max_backup="{{ combined_otvl.git_service.max_backup }}"

# set up environment
. $otvl_sbin_path/otvl_sbin_lib.sh
init_env_backup $otvl_backup_path git

# callbacks and utils
. $otvl_sbin_path/otvl_git_lib.sh

# useful ref http://git-memo.readthedocs.io/en/latest/repository_backup.html
do_backup() {
    git_repo_path="${project_root}/${git_repo}.git"
    cur_dt=`date +%Y%m%d-%H%M%S`
    git_bundle_backup_path="${otvl_backup_path}/git/$git_repo/${git_repo}.bundle.${cur_dt}"
    do_git_backup $git_repo_path $git_bundle_backup_path 1
    status=$?
    if [ $status -eq 0 ] ; then
        # mark no need to check this bundle for restore
        echo $git_bundle_backup_path > $restore_dir/$git_repo/last_restore.txt
        # cleanup old versions
        do_cleanup_after_backup $backup_dir/$git_repo $git_max_backup
    fi
    return $status
}

cd $project_root
for git_repo_git in `ls -d *.git 2> /dev/null`; do
    git_repo=`basename $git_repo_git .git`
    cd $project_root/$git_repo.git && \
        mkdir -p ${otvl_backup_path}/git/$git_repo && \
        do_backup || \
        status=1
done
exit $status
