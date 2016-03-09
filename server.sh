#!/bin/bash

# USAGE: ./server.sh -s s3ql_fs -t s3ql_target_dir [list of folders to be backed up]

#TODO tarsnap
#TODO glacier
#TODO encfs: move to init script.
#TODO s3ql
#TODO help function

local S3QLFS=""
local S3QLDIR=""
local BAKNAME=$(date +"%Y-%m-%d-%H:%m:%S")
local STAGING=""
local ENC_STAGING=false

while true; do
    case $1 in
        h)
            help
            exit 0
            ;;
        s)
            shift
            S3QLFS="$1"
            ;;
        t)
            shift
            S3QLDIR="$1"
            ;;
        staging)
            shift
            STAGING="$1"
            ;;
        enc_staging)
            shift
            ENC_STAGING=true
            ;;
        --)
            shift && break # -- ends options
            ;;
        *-) echo "$0: Unrecognized option $1" >&2
            exit 1
            ;;
        *) break
           ;;
    esac
done

# Remaining args are folders to back up

# Handle s3ql stage. Takes folders to back up as args
s3ql() {
    mount.s3ql "$S3QLFS" "$S3QLDIR"
    local TARGET="$S3QLDIR/$BAKNAME"
    mkdir "$TARGET"

    for folder in "$STAGING/*"; do
        rsync -a "$folder" "$TARGET"
    done

    umount.s3ql3 "$SQLDIR"
}

main() {
    s3ql $@
}

main $@




