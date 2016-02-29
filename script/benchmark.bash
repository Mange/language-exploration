#!/usr/bin/env bash
set -e

hash ab 2>/dev/null || {
echo >&2 "I require ab (Apache Benchmark) but it's not installed. Aborting."
  exit 1
}

. ./script/functions.bash

ab_command="ab -n 5000 -c 8 -s 10 -q"
output_file=benchmark.txt

benchmark() {
  local port=$1
  local server=$2
  local extension=$3

  header "Benchmark $server $extension" | tee -a $output_file

  output=$($ab_command "http://127.0.0.1:${port}/api/current-time.${extension}")

  echo "$output" | tee -a $output_file | grep "Requests per second"
  echo "" | tee -a $output_file
  echo "" | tee -a $output_file
}

build_all_servers
trap "stop_all_servers" EXIT

start_server "go" 3001
start_server "rust" 3002
start_server "ruby" 3003
start_server "node" 3004
start_server "crystal" 3005
sleep 2

echo ""
echo ""

rm -f $output_file

benchmark 3001 Go json
benchmark 3001 Go txt

benchmark 3002 Rust json
benchmark 3002 Rust txt

benchmark 3003 Ruby json
benchmark 3003 Ruby txt

benchmark 3004 Node json
benchmark 3004 Node txt

benchmark 3005 Crystal json
benchmark 3005 Crystal text

header "--------------------"
header "Full output in ${output_file}"
header "--------------------"

stop_all_servers

