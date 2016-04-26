#!/bin/bash

S3QLFS=""
MOUNTPT=""
SOURCE=""

while true; do
    case "$1" in
        -h|--help)
            help
            exit 0
            ;;
        --target)
            shift
            SQLFS="$1"
            ;;
        --source)
            shift
            SOURCE="$1"
            ;;
		--mount)
			shift
{			MOUNTPT="$1"
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
	# Mount s3ql
	mount.s3ql "$TARGET" "$MOUNTPT"
	local DATE=$(date +%Y-%m-%d)
	local DAILY="$MOUNTPT/daily/$DATE"
	
	mkdir -p "$DAILY"
	cp -a "$SOURCE" "$DAILY"

	# If 7 days ago's exists, delete it
	# Gets ugly to support both GNU and BSD
	local LDD=$(date --date="-1 week" +%Y-%m-%d > 2&>/dev/null) || local LDD=$(date -v -7d +%Y-%m-%d)
	local OLDDAY="$MOUNTPT/daily/$LWD"
	if [ -d "$OLDDAY" ]; then; 
	     rm -rf "$OLDDAY"
	fi


	# We do weeklies on Mondays
	if [[ $(date +%a) = "Mon" ]]; then
		local WEEKLY="$MOUNTPT/weekly/$DATE"
		mkdir -p "$WEEKLY"
		cp -a "$SOURCE" "$WEEKLY"

		# If 5 weeks ago's weekly exists, delete it
		local LWD=$(date --date="-5 week" +%Y-%m-%d 2&>/dev/null) || local LWD=$(date -v -5w +%Y-%m-%d)
		local OLDWEEK="$MOUNTPT/weekly/$LWD"
		if [ -d "$OLDWEEK" ]; then
			rm -rf "$OLDWEEK"
		fi
	fi

	# Mothlies come from the Monday preceding the 15th, or the 15th itself if it is a Monday
	if [[ $(date +%d) = "15" ]]; then
		local YEARMONTH=$(date +Y-%m)
		local MONTHLY="$MOUNTPT/monthly/$YEARMONTH"
		mkdir -p "$MONTHLY"
		if [[ "`date +%a`" = "Mon" ]]; then
			cp -a "$SOURCE" "$MONTHLY"
		else
			local SRCWEEK=$(date -dlast-monday +%Y-%m-%d 2&>/dev/null) || local SRCWEEK=$(date -v -Mon +%Y-%m-%d)
			cp -a "$MOUNTPT/weekly/$SRCWEEK" "$MONTHLY"
		fi
		
		# Delete 1 year old monthly
		# If 5 weeks ago's weekly exists, delete it
		local LMD=$(date --date="-1 year" +%Y-%m 2&>/dev/null) || local LWD=$(date -v -1y +%Y-%m)
		local OLDMONTH="$MOUNTPT/monthly/$LMD"
		if [ -d "$OLDMONTH" ]; then
			rm -rf "$OLDMONTH"
		fi

		# Yearlies come from December's monthly, and are never deleted.
		if [[ $(date +%m) = "12" ]]; then
			local YEARLY="$MOUNTPT/yearly/$(date +%Y)"
			mkdir -p "$YEARLY"
			cp -a "$MONTHLY/* $YEARLY"
		fi
	fi

	unmount.s3ql "$MOUNTPT"
}

main()

