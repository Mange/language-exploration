require "json"
require "http/server"
require "time/time"

def time_text
  time = Time.now
  (time.minute >= 30 ? "half past #{time.hour}" : "#{time.hour} O'clock")
end

def time_json
  time = Time.now
  {
    stamp: time.epoch,
    fullstamp: time.epoch_f,
    string: time.to_utc.to_s
  }.to_json
end

port = ENV["PORT"]? ? ENV["PORT"].to_i : 3000
puts "Starting server on port #{port}"

server = HTTP::Server.new(port) do |request|
  case request.path
  when /\/api\/current-time/
    if request.headers["Accept"] =~ /json/ || request.path =~ /json/
      HTTP::Response.ok "application/json", time_json
    else
      HTTP::Response.ok "text/plain", time_text
    end
  else
    HTTP::Response.not_found
  end
end

server.listen

