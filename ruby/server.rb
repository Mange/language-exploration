require "json"
require "bundler/setup"
require "sinatra"

class App < Sinatra::Base
  port = ENV.fetch("PORT", 3000)
  puts "Starting server on port #{port}"

  set :port, port
  set :logging, false

  def time_text
    time = Time.now
    (time.min >= 30 ? "half past #{time.hour}" : "#{time.hour} O'clock")
  end

  def time_json
    time = Time.now
    {
      stamp: time.to_i,
      fullstamp: time.to_f,
      string: time.iso8601,
    }.to_json
  end

  get "/api/current-time", provides: "text" do
    mime_type :text
    time_text
  end

  get "/api/current-time", provides: "json" do
    mime_type :json
    time_json
  end

  get "/api/current-time.json" do
    mime_type :json
    time_json
  end

  get "/api/current-time.txt" do
    mime_type :text
    time_text
  end

  get "*" do
    [404, ["Not Found".freeze]]
  end
end

if __FILE__ == $0
  App.run!
end
