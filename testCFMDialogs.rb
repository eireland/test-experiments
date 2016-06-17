require 'selenium-webdriver'
require 'rspec/expectations'
require './codap_object'
require './codap_base_object'

include RSpec::Matchers

def setup
=begin
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> :safari )
=end
  @driver = Selenium::WebDriver.for :chrome
  ENV['base_url'] = 'http://localhost:4020/dg'
  #ENV['base_url'] = 'http://localhost:4020/dg?di=http://localhost:4020/codap-data-interactives/PerformanceHarness/PerformanceHarness.html'
  #ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
  #ENV['base_url'] = 'http://codap.concord.org/releases/latest/'

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
  codap = CODAPObject.new(@driver)
  buttons = ['examples','cloud','google drive','local']
  codap.user_entry_open_doc
  buttons.each do |button|
    codap.click_button(button)
  end
end
