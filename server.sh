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
    mkdir "$S3QLDIR/$BAKNAME"
    STAGEDIR=`mktemp -d /tmp/bak.XXXXXX` || exit 1
    
    for folder; do
        cp -a "$folder" "$STAGEDIR"
    done

    TMPDIR=`mktemp -d /tmp/bak.XXXXXX` || exit 1

    encfs --reverse "$STAGEDIR" "$TMPDIR"
    cp -a "$TMPDIR/*" "$S3QLDIR/$BAKNAME"
    fusermount -u "$TMPDIR"
    rm -r "$STAGEDIR"
    rm -r "$TMPDIR"
    
    umount.s3ql3 "$SQLDIR"
}

main() {
    s3ql $@
}

main $@




