require 'rest-client'
require 'json'
require 'rspec/expectations'
include RSpec::Matchers


class LogReporter

  def initialize(session_id)
    @session_id = session_id
  end

  def latest
    parse(fetch)#.last
  end

  private

  def fetch
    #puts "Session id is #{@session_id}"
    RestClient.post(
        "http://localhost:4444/wd/hub/session/#{@session_id}/log",
        { "type" => "browser" }.to_json,
        content_type: :json,
        accept: :json
    )
  end

  def parse(input)
    logs = JSON.parse(input)
    messages = []
    logs["value"].each do |entry|
      msg = entry["message"]
      unless msg.include? "session:" or
          msg.include? "fetching logs" or
          msg.include? "execute script"
        messages << msg#.scan(/handle(.*)$/)[-1][-1]
      end
    end
    messages
  end

end