#!/usr/bin/env bash
set -e

if [[ $# != 1 ]]; then
  echo "Usage: $0 PORT" > /dev/stderr
  exit 1
fi

port=$1
url="http://localhost:${port}/api/current-time"

header() {
  printf "\033[34m%25s: %s\033[0m" "$@"
}

header "JSON extension"
curl ${url}.json
echo ""

header "TXT extension"
curl ${url}.txt
echo ""

header "Accept TXT"
curl -H "Accept: text/plain" $url
echo ""

header "Accept JSON"
curl -H "Accept: application/json" $url
echo ""

header "Accept any (expect TXT)"
curl -H "Accept: */*" $url
echo ""

header "No Header (expect TXT)"
curl $url
echo ""
