#!/usr/bin/env bash
set -e

if [[ $# != 1 ]]; then
  echo "Usage: $0 PORT" > /dev/stderr
  exit 1
fi

port=$1

curl -H "Accept: text/plain" http://localhost:${port}/api/current-time
curl -H "Accept: application/json" http://localhost:${port}/api/current-time
