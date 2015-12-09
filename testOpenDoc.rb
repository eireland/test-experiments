require 'selenium-webdriver'
require 'rspec/expectations'
require './codap_object'
include RSpec::Matchers
require './LogReporter'

def setupHelper(session_id)
  @logger = LogReporter.new(session_id)
end

def setup
  caps = Selenium::WebDriver::Remote::Capabilities.new
  caps[:browserName] = :chrome
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> caps )
  setupHelper(@driver.session_id)
  ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
rescue Exception => e
  puts e.message
  puts "Could not start driver #{@browser_name}"
  exit 1
end

def teardown
  puts "in teardown"
  @driver.quit
end

def run
  setup
  yield
  #teardown
end

run do
  codap = CODAPObject.new(@driver)
  open_doc = 'PH_35_Data.json'
  file = File.absolute_path(File.join(Dir.pwd, open_doc))
  puts "file is #{file}, open_doc is #{open_doc}"
  codap.open_local_doc(file)
  open_doc.slice! '.json'
  puts "open_doc is #{open_doc} open_doc_title is #{open_doc_title}"
  sleep(5)
  codap.verify_doc(open_doc)
  # Open table
  # Open Graph
end