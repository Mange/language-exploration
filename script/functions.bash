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

build_all_servers() {
  header "Building"
  rake
}
