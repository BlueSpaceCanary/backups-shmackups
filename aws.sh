#!/bin/bash

AWS_TARGET=""

# Should be an encfs or something like that if you want it encrypted.
AWS_SOURCE=""
DRY_RUN=false
while true; do
    case $1 in
        -h|--help)
            help
            exit 0
            ;;
        --target)
            shift
            AWS_TARGET="$1"
            ;;
        --source)
            shift
            AWS_SOURCE="$1"
            ;;
        --dry-run)
            shift
            DRY_RUN=true
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
    local DATE=$(date +%Y-%m-%d)
    local DAILY="$TARGET/daily/$DATE"
    echo "Uploading daily to $TARGET/daily/$DATE"
    if [ "$bool" != true ]; then
        aws s3 "$SOURCE" "$TARGET/daily/$DATE"
    fi
}

main()
