# This will click on all the buttons in the CODAP toolshelf except for the table and the guide. Tables do not open unless there is data. Guides do not open if there is no guide specified in configuration.

require 'selenium-webdriver'
require 'rspec/expectations'
require './codap_object'
include RSpec::Matchers
require './LogReporter'

def setupHelper(session_id)
  @logger = LogReporter.new(session_id)
end

def setup(browser_name, platform)
  caps = Selenium::WebDriver::Remote::Capabilities.new
  puts "Before case, browser name is #{browser_name}, platform name is #{platform}"
  case (platform)
    when "windows"
      caps[:platform] = "Windows"
      case (browser_name)
        when :firefox
          caps[:browserName] = :firefox
        when :chrome
          caps[:browserName] = :chrome
        when :ie
          caps[:browserName] = 'internet explorer'
      end
    when "mac"
      caps[:platform] = 'OS X'
      case (browser_name)
        when :firefox
          caps[:browserName] = :firefox
        when :chrome
          caps[:browserName] = :chrome
        when :safari
          caps[:browserName] = :safari
      end
  end
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> caps )
  setupHelper(@driver.session_id)
  #ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
  ENV['base_url'] = 'http://codap.concord.org/releases/latest/static/dg/en/cert/index.html'
  puts "platform is #{@driver.capabilities.platform}, browser is #{@driver.capabilities.browser_name}"
rescue Exception => e
  puts e.message
  puts "Could not start driver #{@browser_name}"
  exit 1
end


def teardown
  puts "in teardown"
  @driver.quit
end


MACBROWSERS = [:chrome, :firefox]
WINBROWSERS = [:firefox, :chrome, :ie]

def run
  MACBROWSERS.each do |macbrowser|
    puts macbrowser
    setup(macbrowser, "mac")
    yield
    teardown
  end
  WINBROWSERS.each do |winbrowser|
    puts winbrowser
    setup(winbrowser, "windows")
    yield
    teardown
  end
end

run do
  components = ['graph','map','slider','calc','text','option','tile']
  codap = CODAPObject.new(@driver)
  codap.start_new_doc
  components.each do |component|
    codap.click_button(component)
  end
  puts @logger.latest if @driver.capabilities.browser_name !='internet explorer'
  #TODO Needs assertions for each button click
end
