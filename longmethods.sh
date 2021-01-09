#!/bin/bash

TMP_NOT_SORTED="/tmp/temp"
TMP_SORTED="/tmp/temp_sorted"
# Default behavior for limit of results and method lengths
IS_LONG_FROM=38
RESULT_LIMIT=50

# options stuff
for arg in "$@"; do
  shift
  case "$arg" in
  "--directory") set -- "$@" "-d" ;;
  "--isLongFrom") set -- "$@" "-f" ;;
  "--limit") set -- "$@" "-l" ;;
  *) set -- "$@" "$arg" ;;
  esac
done

# Parse short options
while getopts "f:l:d:" opt; do
  case "$opt" in
  "d") SEARCH_PATH=$OPTARG ;;
  "f") IS_LONG_FROM=$OPTARG ;;
  "l") RESULT_LIMIT=$OPTARG ;;
  ?) echo "unsupported options. Please use -d (--directory), -l (--limit) or -f (--isLongFrom) " ;;
  esac
done

if [ -z "$SEARCH_PATH" ]; then
  echo "please run the script with -d option for scanning project path"
  exit 1
fi

# make sure given path exists and is a directory
if ! [[ -d $SEARCH_PATH ]]; then
  echo "given directory does not exist"
  exit 1
fi

# shellcheck disable=SC2162
read -p "include test packages? (y/n)? " include_test

case $include_test in
y | Y) echo "test packages are included" ;;
n | N) echo "test packages are not included" ;;
*)
  echo "invalid answer (y/n)"
  exit 1
  ;;
esac

function createOrTruncateFile() {
  # some default operations for temp files
  if [[ -f "$1" ]]; then
    truncate -s 0 "$1"
  else
    touch "$1"
  fi
}

createOrTruncateFile $TMP_NOT_SORTED
createOrTruncateFile $TMP_SORTED

# rocket science - search directory for long methods
if [[ $include_test == "y" ]]; then
  find "${SEARCH_PATH}"* -name "*.java" -not -path "*/target*" -not -path "*/out*" -exec \
    sed -n -r '/(public|protected|private|static|void)/p' {} \; |
    sed -r '/(final|class|import|\;|=|enum|[*]|[/])/d ; /()/s/[(].*$// ; s/.* //; /^.$/d ; /^[A-Z]./d' >>$TMP_NOT_SORTED
else
  find "${SEARCH_PATH}"* -name "*.java" -not -path "*/target*" -not -path "*/out*" -not -path "*/test*" -exec \
    sed -n -r '/(public|protected|private|static|void)/p' {} \; |
    sed -r '/(final|class|import|\;|=|enum)|[*]|[/]/d ; /()/s/[(].*$// ; s/.* //; /^.$/d ; /^[A-Z]./d' >>$TMP_NOT_SORTED
fi

# next pipeline: sort temp-file/methods by length (descending)
awk '{ print length($0) " " $0; }' $TMP_NOT_SORTED | sort -r -n | uniq | cut -d " " -f2- | head --lines="$RESULT_LIMIT" >$TMP_SORTED

RED='\033[0;31m\e[1m'
YELLOW='\033[0;33m\e[1m'
DEFAULT='\e[0m'

function printLineAndSleep() {
  echo -e "$1"
  sleep "$2"
}

# print sorted methods in color depending on the length
COUNTER=0
NUMBER_LONG_METHODS=0
while IFS= read -r line; do
  length=$(echo "{$line}" | wc -c)
  if ((length > IS_LONG_FROM)); then
    text=${RED}${line}${DEFAULT}
    NUMBER_LONG_METHODS=$((NUMBER_LONG_METHODS + 1))
  elif ((length > ((IS_LONG_FROM - 5)))); then
    text=${YELLOW}${line}${DEFAULT}
  else
    break
  fi
  printLineAndSleep "${text}""()" 0.08
  COUNTER=$((COUNTER + 1))
  if [[ "$COUNTER" == "$RESULT_LIMIT" ]]; then
    break
  fi
done <$TMP_SORTED

printf "\n"

# print statistic
NUMBER_ALL_METHODS=$(wc -w ${TMP_SORTED} | awk '{ print $1 }')
echo "(${NUMBER_LONG_METHODS}/${NUMBER_ALL_METHODS}) methods are too long"

# delete temp files
function deleteTempFiles() {
  rm "$1"
}

deleteTempFiles $TMP_NOT_SORTED
deleteTempFiles $TMP_SORTED
