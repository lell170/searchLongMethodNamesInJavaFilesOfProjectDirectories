#!/bin/bash

SEARCH_PATH=$1
TMP_NOT_SORTED="/tmp/temp"
TMP_SORTED="/tmp/temp_sorted"
RESULT_LIMIT=$2

if [ $# -ne 2 ]; then
  echo "Please enter two parameters"
  exit 1
fi

# make sure given directory exist and is an directory
if ! [ -d "$SEARCH_PATH" ]; then
  echo "given directory is not exist"
  exit 1
fi

# make sure second parameter is an number
if ! [[ "$RESULT_LIMIT" =~ ^[0-9]+$ ]]; then
  echo "given second parameter is not an number"
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
awk '{ print length($0) " " $0; }' $TMP_NOT_SORTED | sort -r -n | uniq | cut -d " " -f2- >$TMP_SORTED

RED='\033[0;31m\e[1m'
YELLOW='\033[0;33m\e[1m'
GREEN='\033[0;36m\e[1m'
DEFAULT='\e[0m'

function printLineAndSleep() {
  echo -e "$1"
  sleep "$2"
}

# old while loop
COUNTER=0
while IFS= read -r line; do
  length=$(echo "{$line}" | wc -c)
  if ((length > 37)); then
    text=${RED}$line${DEFAULT}
  elif ((length > 35)); then
    text=${YELLOW}$line${DEFAULT}
  else
    text=${GREEN}$line${DEFAULT}
  fi
  printLineAndSleep "$text""()" 0.08
  COUNTER=$((COUNTER + 1))
  if [[ "$COUNTER" == "$RESULT_LIMIT" ]]; then
    break
  fi
done <"$TMP_SORTED"

printf "\n"

function deleteTempFiles() {
  rm "$1"
}

deleteTempFiles $TMP_NOT_SORTED
deleteTempFiles $TMP_SORTED