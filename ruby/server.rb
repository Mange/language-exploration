require "json"
require "bundler/setup"
require "sinatra"

set :port, ENV.fetch("PORT", 3000)

get "/api/current-time", provides: "text" do
  time = Time.now
  body = (time.min > 30 ? "half past #{time.hour}" : "#{time.hour} O'clock")
  [200, [body, "\n".freeze]]
end

get "/api/current-time", provides: "json" do
  time = Time.now
  body = {
    stamp: time.to_i,
    fullstamp: time.to_f,
    string: time.iso8601,
  }
  [200, [body.to_json, "\n"]]
end

get "*" do
  [404, ["Not Found\n".freeze]]
end
