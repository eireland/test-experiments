require 'rspec/expectations'
require 'selenium-webdriver'
include RSpec::Matchers

def setup(browser_name)
  begin
    @driver = Selenium::WebDriver.for browser_name
  rescue Exception => e
      puts e.message
      puts "Could not start driver"
      exit 1
  end
end

def teardown
  @driver.quit
end

BROWSERS = [:firefox, :chrome, :safari]

def run
  BROWSERS.each do |browser|
    puts browser
    setup(browser)
    yield
    teardown
  end
end

run do
  @driver.get "http://the-internet.herokuapp.com"
  expect(@driver.title).to eql("The Internet")
end

