#!/bin/sh

# git_init_bare_util.sh <repo>
status=0
otvl_sbin_path="{{ combined_otvl.config_paths.sbin }}"
project_root="{{ combined_otvl.apache.www }}/{{ combined_otvl.git_service.project_root }}"
apache_user="{{ combined_otvl.git_service.user }}"
apache_group="{{ combined_otvl.git_service.group }}"
git_repo=$1
shift
if [ -z "$git_repo" ] ; then
    echo >&2 git_repo must be set
    exit 1
fi
if [ -d ${project_root}/${git_repo}.git ] ; then
    echo >&2 "${project_root}/${git_repo}.git already exists"
    exit 1
fi
${otvl_sbin_path}/git_init_bare_install.sh \
        ${project_root} ${git_repo} \
        ${apache_user} ${apache_group} || \
    status=1

exit $status
