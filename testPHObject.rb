require 'selenium-webdriver'
require 'rspec/expectations'
require './performance_harness_object'
include RSpec::Matchers


def setup

  caps = Selenium::Webdriver::Remote::Capablities.firefox
  caps[:log_type] = 'ALL'
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities => caps)

  #@driver = Selenium::WebDriver.for :firefox
  #ENV['base_url'] = 'http://localhost:4020/dg?di=http://localhost:4020/codap-data-interactives/PerformanceHarness/PerformanceHarness.html'
  ENV['base_url'] = 'http://codap.concord.org/releases/latest/?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html'
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
$i=0
  ph = PerformanceHarnessObject.new(@driver)
  begin
    num_trials = 50
    delay = 1
    ph.start_sim(num_trials, delay)
    if ph.status_result_present? 'Time = '
      time_result = ph.get_time_result(time_result)
      rate_result = ph.get_rate_result(rate_result)
    end
    puts "Time: #{time_result} Rate: #{rate_result}"
    log = @driver.manage.logs.get :firefox
    @driver.save_screenshot "CODAPshot.png"
    puts "Log from browser is #{log}"
    $i +=1
  end while $i < 6
end