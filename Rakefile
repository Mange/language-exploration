require "fileutils"
require "shellwords"

file "go/server.go"

task :godeps do
  `cd go && go get -v ./...`
end

task :go => ["go/server.go", :godeps] do
  `cd go && go build -o server server.go`
end
