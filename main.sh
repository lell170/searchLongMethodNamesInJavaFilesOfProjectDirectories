#!/bin/bash

SEARCH_PATH=$1
TMP_NOT_SORTED="/tmp/temp"
TMP_SORTED="/tmp/temp_sorted"

# make sure the parameter for path is given
if [ $# -ne 1 ]; then
  echo "Please enter one parameter"
  exit 1
fi

# make sure given directory exist and is an directory
if ! [ -d "$SEARCH_PATH" ]; then
  echo "given directory is not exist"
  exit 1
fi

function createOrTruncateTmpFiles() {
  # some default operations for temp files
  if [ -f "$1" ]; then
    truncate -s 0 "$1"
  else
    touch "$1"
  fi
}

createOrTruncateTmpFiles $TMP_NOT_SORTED
createOrTruncateTmpFiles $TMP_SORTED

# rocket science
find "$SEARCH_PATH"* -name "*.java" -not -path "*/target*" -not -path "*/out*" -exec \
  sed -n -r '/(public|protected|private|static|void)/p' {} \; |
  sed -r '/(final|class|import|\;|=|enum)/d ; /()/s/[(].*$// ; s/.* //; /^.$/d' >>$TMP_NOT_SORTED

# next pipeline...
awk '{ print length($0) " " $0; }' $TMP_NOT_SORTED | sort -r -n -u >$TMP_SORTED

head -15 $TMP_SORTED

function deleteTempFiles() {
  rm "$1";
}

deleteTempFiles $TMP_NOT_SORTED;
deleteTempFiles $TMP_SORTED;
