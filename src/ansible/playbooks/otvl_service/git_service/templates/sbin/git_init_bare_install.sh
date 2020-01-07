#!/bin/sh
# git_init_bare_install.sh <project_root> <git_repo> <apache_user> <apache_group>
status=0

project_root=$1
shift
git_repo=$1
shift
apache_user=$1
shift
apache_group=$1
shift
if [ -z "$project_root" ] ; then
    echo >&2 project_root must be set
    exit 1
fi
if [ -z "$git_repo" ] ; then
    echo >&2 git_repo must be set
    exit 1
fi

cd ${project_root} && \
git init --bare --shared ${git_repo}.git && \
cd ${git_repo}.git && \
git config http.receivepack true && \
cd ${project_root} && \
chown -R ${apache_user}:${apache_group} ${git_repo}.git || \
status=1
if [ $status -ne 0 ] ; then
    cd
    if [ -d ${project_root}/${git_repo}.git ] ; then
        rm -r ${project_root}/${git_repo}.git
    fi
fi
exit $status