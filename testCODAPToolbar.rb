require 'selenium-webdriver'
require 'rspec/expectations'
require './codap_object'
include RSpec::Matchers
require './LogReporter'

def setupHelper(session_id)
  @logger = LogReporter.new(session_id)
end


def setupMac(browser_name, platform)
  caps = Selenium::WebDriver::Remote::Capabilities.new
  puts "Before case, browser name is #{browser_name}, platform name is #{platform}"
  caps[:platform] = 'OS X'
  case (browser_name)
    when :firefox
      caps[:browserName] = :firefox
    when :chrome
      caps[:browserName] = :chrome
    when :ie
      caps[:browserName] = :safari
  end

  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> browser_name)
  setupHelper(@driver.session_id)
  ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
  puts "platform is #{@driver.capabilities.platform}, browser is #{@driver.capabilities.browser_name}"
rescue Exception => e
  puts e.message
  puts "Could not start driver"
  exit 1
end

def setupWin(browser_name, platform)
  caps = Selenium::WebDriver::Remote::Capabilities.new
  puts "Before case, browser name is #{browser_name}, platform name is #{platform}"
  caps[:platform] = "Windows"
  case (browser_name)
    when :firefox
      caps[:browserName] = :firefox
    when :chrome
      caps[:browserName] = :chrome
    when :ie
      caps[:browserName] = 'internet explorer'
  end

      @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> caps )
  setupHelper(@driver.session_id)
  ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
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

MACBROWSERS = [:firefox, :chrome]
WINBROWSERS = [:firefox, :chrome, :ie]

def run
  MACBROWSERS.each do |macbrowser|
    puts macbrowser
    setupMac(macbrowser, "mac")
    yield
    teardown
  end
  WINBROWSERS.each do |winbrowser|
    puts winbrowser
    setupWin(winbrowser, "windows")
    yield
    teardown
  end
end

run do
  codap = CODAPObject.new(@driver)
  codap.start_new_doc
  codap.click_table_button
  codap.click_graph_button
  codap.click_map_button
  codap.click_slider_button
  codap.click_calc_button
  codap.click_text_button
  codap.click_option_button
  codap.click_tilelist_button
  #codap.click_guide_button
  puts @logger.latest if @driver.capabilities.browser_name !='internet explorer'
end
