#!/bin/sh

# git_restore_util.sh <repo>
status=0
otvl_sbin_path="{{ combined_otvl.config_paths.sbin }}"
project_root="{{ combined_otvl.apache.www }}/{{ combined_otvl.git_service.project_root }}"
apache_user="{{ combined_otvl.git_service.user }}"
apache_group="{{ combined_otvl.git_service.group }}"
otvl_backup_path="{{ combined_otvl.config_paths.backup }}"

git_repo=$1
shift
if [ -z "$git_repo" ] ; then
    echo >&2 git_repo must be set
    exit 1
fi
if [ ! -d ${project_root}/${git_repo}.git ] ; then
    ${otvl_sbin_path}/git_init_bare_util.sh ${git_repo} || exit 1
fi
check_cmd="${otvl_sbin_path}/git_restore_install.sh --check ${project_root} ${git_repo} ${apache_user} ${apache_group} ${otvl_backup_path}"
cmd="${otvl_sbin_path}/git_restore_install.sh ${project_root} ${git_repo} ${apache_user} ${apache_group} ${otvl_backup_path}"
out=`$check_cmd`
if [ $? -ne 0 ] ; then
    status=1
    exit $status
fi
if [ -z "$out" ] ; then
    exit $status
fi
echo $out >&2
$cmd
if [ $? -ne 0 ] ; then
    status=1
    exit $status
fi
exit $status