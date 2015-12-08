require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

def setup
  @driver = Selenium::WebDriver.for :firefox
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
  @driver.get 'http://the-internet.herokuapp.com'

  # Step 1: check for jQuery on the page, add it if needbe
  @driver.execute_script("if (!window.jQuery) {
    var jquery = document.createElement('script'); jquery.type = 'text/javascript';
    jquery.src = 'https://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js';
    document.getElementsByTagName('head')[0].appendChild(jquery);
  }")

  # Step 2: use jQuery to add jquery-growl to the page
  @driver.execute_script("$.getScript('http://the-internet.herokuapp.com/js/vendor/jquery.growl.js')")

  # Step 3: use jQuery to add jquery-growl styles to the page
  @driver.execute_script("$('head').append('<link rel=\"stylesheet\" href=\"http://the-internet.herokuapp.com/css/jquery.growl.css\" type=\"text/css\" />');")

  # Step 4: display a message with jquery-growl
  @driver.execute_script("$.growl({ title: 'GET', message: '/' });")
  @driver.execute_script("$.growl.error({ title: 'ERROR', message: 'your error message goes here' });")
  @driver.execute_script("$.growl.notice({ title: 'Notice', message: 'your notice message goes here' });")
  @driver.execute_script("$.growl.warning({ title: 'Warning!', message: 'your warning message goes here' });")

  sleep 5 # to keep the browser active long enough to see the notifications
end