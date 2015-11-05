require 'rspec/expectations'
require 'selenium-webdriver'
include RSpec::Matchers

def setupMac(browser_name)
  @driver = Selenium::WebDriver.for browser_name
rescue Exception => e
  puts e.message
  puts "Could not start driver"
  exit 1

end

def setupWin(browser_name)
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> browser_name)
rescue Exception => e
  puts e.message
  puts "Could not start driver #{@browser_name}"
  exit 1
end

def teardown
  puts "in teardown"
  @driver.quit
end

MACBROWSERS = [:firefox, :chrome, :safari]
WINBROWSERS = [:firefox, :chrome, :ie]

def run
  MACBROWSERS.each do |macbrowser|
    puts macbrowser
    setupMac(macbrowser)
    yield
    teardown
  end
  WINBROWSERS.each do |winbrowser|
    puts winbrowser
    setupWin(winbrowser)
    yield
    teardown
  end
end

run do
  @driver.get "http://the-internet.herokuapp.com"
  puts  @driver.capabilities.browser_name
  @browser_name=@driver.capabilities.browser_name

  begin
    if @browser_name == "internet explorer"
      puts ("#{@browser_name} inside if statement")
      expect(@driver.title).to eql("WebDriver")
    else
      puts ("#{@browser_name} inside else statement")
      expect(@driver.title).to eql("The Internet")
    end
    rescue Exception => e
      puts e.message
       #puts "Could not start driver #{@browser_name}"
       #exit 1
    end
end



