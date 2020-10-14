#!/usr/bin/env bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>newbookmark.log 2>&1

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  echo "** Trapped CTRL-C"
}

for i in `seq 1 5`; do
  sleep 1
  echo -n "."
done

# Get a copy of bookmarks in xml format and save it on the Desktop
plutil -convert xml1 -o ~/Desktop/SafariBookmarks.xml ~/Library/Safari/Bookmarks.plist

# Create new temp file that has the title and url only in plain format and store it in a file called temp on the Desktop
grep -A1 -E '(>URLString<|>title<)' /Users/x/Desktop/SafariBookmarks.xml |grep -v -E '(>URLString|>title|^--)' | cut -d\> -f2 | cut -d\< -f1  >> /Users/x/Desktop/temp

mysql  < /Users/x/.Scripts/Bookmark-db/sql.sql

# Clean Up
rm /Users/x/Desktop/SafariBookmarks.xml || true
rm /Users/x/Desktop/temp || true

exit 0
