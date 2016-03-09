#!/bin/bash

# USAGE: ./client.sh -s remote_server:remote_folder -i /path/to/ssh/key [list of folders to be staged]

#TODO create help function

while true; do
    case "$1" in
        h)
            help
            exit 0
            ;;
        s)
            shift
            REMOTE="$1"
            ;;
        i)
            shift
            KEY="$1"
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

# Remaining args are all folders to stage

TMPDIR=`mktemp -d /tmp/bak.XXXXXX` || exit 1

while [[ $# > 0 ]]
do
    obj=$1
    ln -s "$obj" "$TMPDIR"
done

# Rsync tmp staging dir, treating links as the real targets, to remote
rsync -aLz -i "$KEY" "$TMPDIR" "$REMOTE"

rm -r "$TMPDIR"


