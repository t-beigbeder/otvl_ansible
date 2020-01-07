#!/usr/bin/env sh

log() {
  TS=`date +%Y/%m/%d" "%H:%M:%S",000"`
  echo "$TS | $1 | script: $2"
}

error() {
  log ERROR "$1"
}

warn() {
  log WARNING "$1"
}

info() {
  log INFO "$1"
}

run_command() {
    info "run command \"$*\""
    "$@" || (error "while running command \"$*\"" && return 1)
}

compose_up_test_down() {
    st=0
    up=0
    dc_up || (error "dc_up" && return 1)
    st=$?
    if [ $st -eq 0 ] ; then
        up=1 && trap dc_down INT
    fi
    if [ $st -eq 0 ] ; then
        run_test || (error "run_test" && return 1)
        st=$?
    fi
    if [ $up -eq 1 ] ; then
        dc_down || (error "dc_down" && return 1)
    fi
    return $st
}

if [ "$DEV" ] ; then
    init_dev
fi