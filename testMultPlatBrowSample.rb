require 'rspec/expectations'
require 'selenium-webdriver'
require 'rspec'
include RSpec::Matchers

def setup
  # caps[:browsers] = [:firefox, :chrome]
  # caps[:platform] = [:win, :mac]
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> :ie) # you can also use :chrome, :safari, etc.
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

run do
  begin
    @driver.get 'http://the-internet.herokuapp.com'
    expect(@driver.title).to eq('The Internet')
    rescue
      exit 1
   end
end

