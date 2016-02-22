require 'selenium-webdriver'
require 'rspec/expectations'
require './codap_object'
include RSpec::Matchers


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
  ENV['base_url'] = 'http://codap.concord.org/releases/latest/'
  #ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
  #ENV['base_url'] = 'localhost:4020/dg'
rescue Exception => e
  puts e.message
  puts "Could not start driver #{@browser_name}"
  exit 1
end

def teardown
  puts "in teardown"
  @driver.quit
end

MACBROWSERS = [:chrome]

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
    codap.start_new_doc
    codap.open_file_menu
    codap.select_file_menu_open_doc
#Need to close file and open next one
end