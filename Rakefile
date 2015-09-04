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

### Rust ###
namespace :rust do
  task :deps do
    # Handled in the build step instead
  end

  file(
    "rust/target/debug/server" =>
      FileList["rust/Cargo.toml", "rust/src/**/*.rs"]
  ) do
    `cd rust && cargo build`
  end

  file "rust/server" => ["rust/target/debug/server"] do
    `cd rust && ([ -e server ] || ln target/debug/server server)`
  end

  task build: ["rust/server"]
end

### Ruby ###
namespace :ruby do
  file "ruby/Gemfile.lock" => "ruby/Gemfile" do
    `cd ruby && bundle install`
  end

  task :deps => ["ruby/Gemfile.lock"]

  task build: [:deps] do
    # Nothing to compile
  end
end

### Basics ###
multitask deps: [:"ruby:deps", :"go:deps", :"rust:deps"]
multitask build: [:deps, :"ruby:build", :"go:build", :"rust:deps"]

task default: :build
