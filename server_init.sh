#!/bin/bash

local S3QLFS=""
local STAGING=""
local ENC_STAGING=""

while true; do
    case "$1" in
        h|help)
            help
            exit 0
            ;;
        s3ql)
            shift
            SQLFS="$1"
            ;;
        staging)
            shift
            STAGING="$1"
            ;;
        enc_staging)
            shift
            ENC_STAGING="$1"
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

main() {
    # If S3QLFS was specified, create it
    if [ ! -z "$S3QLFS" ]; then
       mkfs.s3ql "$S3QLFS"
    fi

    # If we're using an ENCFS, mount it.
    if [ ! -z "$ENC_STAGING" ]; then
        encfs --reverse "$STAGING" "$ENC_STAGING" 
    fi
}
            
