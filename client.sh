#!/bin/bash

# USAGE: ./client.sh -s remote_server:remote_folder -i /path/to/ssh/key [list of folders to be staged]

#TODO create help function

while getopts "h?s:i:" opt; do
    case "$opt" in
        h|\?)
            help
            exit 0
            ;;
        s)
            REMOTE="$OPTARG"
            ;;
        i)
            KEY="$OPTARG"
            ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift # If -- terminated options, shift it off

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


