require "fileutils"

### Go ###
namespace :go do
  task :deps do
    `cd go && go get -v ./...`
  end

  task :build => ["go/server.go", :deps] do
    `cd go && go build -o server server.go`
  end
end

### Ruby ###
namespace :ruby do
  file "ruby/Gemfile.lock" => "ruby/Gemfile" do
    `cd ruby && bundle install`
  end

  task :deps => ["ruby/Gemfile.lock"]

  task :build do
    # Nothing to compile
  end
end

### Basics ###
multitask deps: [:"ruby:deps", :"go:deps"]
multitask build: [:deps, :"ruby:build", :"go:build"]

task default: :build
