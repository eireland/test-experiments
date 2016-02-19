require 'selenium-webdriver'
require 'rspec/expectations'
require './codap_object'
include RSpec::Matchers
require './LogReporter'

def setupHelper(session_id)
  @logger = LogReporter.new(session_id)
end

def setup(browser_name)
  caps = Selenium::WebDriver::Remote::Capabilities.new
  case (browser_name)
    when :firefox
      caps[:browserName] = :firefox
      caps[:logging_prefs] = {:browser => "ALL"}
    when :chrome
      caps[:browserName] = :chrome
      caps[:logging_prefs] = {:browser => "ALL"}
    when :safari
      caps[:browserName] = :safari
      caps[:logging_prefs] = {:browser => "ALL"}
  end
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> caps )
  setupHelper(@driver.session_id)
  ENV['base_url'] = 'http://codap.concord.org/releases/latest/'
  #ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
  #ENV['base_url'] = 'localhost:4020/dg'
  dnd_javascript = File.read(Dir.pwd + '/dnd.js')
rescue Exception => e
  puts e.message
  puts "Could not start driver #{@browser_name}"
  exit 1
end

def teardown
  puts "in teardown"
  @driver.quit
end

MACBROWSERS = [:firefox, :chrome]

def run
  MACBROWSERS.each do |macbrowser|
    puts macbrowser
    setup(macbrowser)
    yield
    #teardown
  end
end

run do
  codap = CODAPObject.new(@driver)
  open_doc = 'PH_35_Data.json'
  file = File.absolute_path(File.join(Dir.pwd, open_doc))
  puts "file is #{file}, open_doc is #{open_doc}"
  codap.open_local_doc(file)
  open_doc.slice! '.json'
  puts "open_doc is #{open_doc}"
  #sleep(5)
  codap.verify_doc(open_doc)
  codap.click_table_button
  codap.click_graph_button
  codap.drag_attribute('trial','x')
  puts @driver.manage.logs.get(:browser)
  codap.drag_attribute('randNum','y')
  puts @driver.manage.logs.get(:browser)
  codap.drag_attribute('choice','legend')
  puts @driver.manage.logs.get(:browser)
  #puts @logger.latest
end