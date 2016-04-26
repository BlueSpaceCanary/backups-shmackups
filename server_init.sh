#!/bin/bash
# USAGE: ./server_init.sh

S3QLFS=""
STAGING=""
ENC_STAGING=""

help() {
    echo "Performs initial setup for a machine to act as a backup-schmackup server.
--s3ql foo will create a S3QL filesystem called foo.
--enc_staging instructs us to create an EncFS of the staging directory.
--staging foo specifies that foo is the directory into which data to be backed up is staged
--help and -h print this message."
}

while true; do
    case "$1" in
        -h|--help)
            help
            exit 0
            ;;
        --s3ql)
            shift
            S3QLFS="$1"
            ;;
        --staging)
            shift
            STAGING="$1"
            ;;
        --enc_staging)
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
    # If S3QLFS was specified, mount it
    if [ ! -z "$S3QLFS" ]; then
       mkfs.s3ql "$S3QLFS"
    fi

    # If we're using an ENCFS, mount it. Might also create it.
    if [ ! -z "$ENC_STAGING" ]; then
        encfs --reverse "$STAGING" "$ENC_STAGING" 
    fi
}
            
