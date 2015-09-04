#!/usr/bin/env bash
set -e
. ./script/functions.bash

build_all_servers
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
