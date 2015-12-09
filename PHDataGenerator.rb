require 'rubygems'
require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

counter=0
total_trials=10
num_cases = 1000
delay = 1
sleep_time = 1
total_time = 0
total_rate = 0

@browser = Selenium::WebDriver.for :chrome
url = "http://codap.concord.org/releases/latest/static/dg/en/cert/index.html?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html"
#@browser.get "http://localhost:4020/dg?moreGames=[{%22name%22:%22PerformanceHarness%22,%22dimensions%22:{%22width%22:550,%22height%22:500},%22url%22:%22http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html%22}]&componentMode=yes"
@wait= Selenium::WebDriver::Wait.new(:timeout=>60)
@browser.get(url)

puts "Page title is #{@browser.title}"
#Checks if correct document is on screen
if @browser.title == "Untitled Document - CODAP"
  puts "Got right document"
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
else
  puts "Got wrong page"
end

# if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
#   @wait.until{@browser.find_element(:css=>'.focus')}.click
# end



frame = @browser.find_element(:css, "iframe")

@browser.switch_to.frame(frame)

trials = @browser.find_element(:name=>'numTrials')
trials.clear
trials.send_keys(num_cases)
run_button = @wait.until{@browser.find_element(:name=>'run')}

while counter < total_trials.to_i do
  if run_button.enabled?
    sleep(sleep_time)
    run_button.click
    time_result=@wait.until{
      time_element = @browser.find_element(:id=>'time')
      time_element if time_element.displayed?
    }

    rate_result=@wait.until{@browser.find_element(:id=>'rate')}

    duration=time_result.text.to_f
    rate = rate_result.text.to_f
    total_time=total_time+duration
    total_rate = total_rate+rate

    puts "Time:#{@time}, Platform: #{@platform}, Browser: #{@browser_name} v.#{@browser_version}, Testing: #{$build},
            Trial no. #{counter}, Number of cases: #{num_cases}, Delay: #{delay} s, Time result: #{time_result.text} ms, Rate result: #{rate_result.text} cases/sec \n"
    counter=counter+1
    @browser.switch_to.default_content

    @browser.switch_to.frame(frame)
  end

end
`say "I'm done Yoda"`
#@browser.quit






=begin
require 'selenium-webdriver'
require 'rspec/expectations'
require './performance_harness_object'
include RSpec::Matchers


def setup
  caps = Selenium::WebDriver::Remote::Capabilities.new
  caps[:browserName] = :chrome
  #caps[:log_type] = 'ALL'
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
  #teardown
end

run do
  $i=0
  ph = PerformanceHarnessObject.new(@driver)
  until $i >= 10
    num_trials = 350
    delay = 1
    ph.start_sim(num_trials, delay)
    if ph.status_result_present? 'Time = '
      time_result = ph.get_time_result(time_result)
      rate_result = ph.get_rate_result(rate_result)
    end
    puts "Time: #{time_result} Rate: #{rate_result}"
    $i +=1
  end
  `say "I'm done Yoda"`
end
=end
