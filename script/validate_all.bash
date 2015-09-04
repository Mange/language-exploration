#!/usr/bin/env bash
set -e

header() {
  echo -e "\033[33m--- $@ ---\033[0m"
}

stop_server() {
  (set +e; kill -TERM $1)
  sleep 1
  if ps -p $1 >/dev/null; then
    (set +e; kill -KILL $1)
  fi
}

start_server() {
  header "Starting $1 server"
  (PORT=$2 $1/server) &
  sleep 1
}

stop_all_servers() {
  header "Shutting down all servers"
  for pid in $(jobs -p); do
    (set +e; stop_server $pid)
  done
}

header "Building"
rake

trap "stop_all_servers" ERR

start_server "go" 3001
start_server "rust" 3002
start_server "ruby" 3003
sleep 1

header "Testing Go"
time ./script/run_test.bash 3001

header "Testing Rust"
time ./script/run_test.bash 3002

header "Testing Ruby"
time ./script/run_test.bash 3003

stop_all_servers
