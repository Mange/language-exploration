require "fileutils"
require "shellwords"

### Go ###
path = ENV['GOPATH']
if path.nil? || !File.directory?(path)
  puts "It seems like your $GOPATH isn't set up correctly. Please follow the Go installation instructions."
  exit 1
end
GOPATH = path.freeze
GODEPS = [
  "github.com/julienschmidt/httprouter".freeze,
].freeze

namespace :go do
  file "go/server" => ["go/server.go"] do
    `cd go && go build -o server server.go`
  end

  GODEPS.each do |dependency|
    path = File.join(GOPATH, "src", dependency)

    directory path do
      `go get #{dependency.shellescape}`
    end

    file "go/server" => path
  end

  desc "Build the Go server"
  task build: ["go/server"]

  desc "Clean the build"
  task :clean do
    FileUtils.rm_f "go/server"
  end
end

### Rust ###
namespace :rust do
  file("rust/target/debug/server" =>
      FileList["rust/Cargo.toml", "rust/src/**/*.rs"]
  ) do
    `cd rust && cargo build`
  end

  file "rust/server" => ["rust/target/debug/server"] do
    `cd rust && ln -fs target/debug/server server`
  end

  desc "Build the Rust server"
  task build: ["rust/server"]

  desc "Clean the build"
  task :clean do
    FileUtils.rm_rf "rust/target"
    FileUtils.rm_rf "rust/server"
  end
end

### Ruby ###
namespace :ruby do
  file "ruby/Gemfile.lock" => "ruby/Gemfile" do
    `cd ruby && bundle install`
  end

  desc "Install the Ruby dependencies"
  task build: ["ruby/Gemfile.lock"]
end

### Basics ###
desc "Clean out all generated files"
multitask clean: [:"go:clean", :"rust:clean"]

desc "Build all servers (default)"
multitask build: [:"ruby:build", :"go:build", :"rust:build"]

desc "Run tests"
task :test do
  system('./script/validate_all.bash')
end

task default: :build
