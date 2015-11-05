require 'rubygems'
require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

counter=0
total_trials=2
num_cases = 500
delay = 1
sleep_time = 1
total_time = 0
total_rate = 0

@browser = Selenium::WebDriver.for :safari
url = "http://codap.concord.org/releases/latest/static/dg/en/cert/index.html?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html"
#@browser.get "http://localhost:4020/dg?moreGames=[{%22name%22:%22PerformanceHarness%22,%22dimensions%22:{%22width%22:550,%22height%22:500},%22url%22:%22http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html%22}]&componentMode=yes"
@browser.get(url)

puts "Page title is #{@browser.title}"
#Checks if correct document is on screen
if @browser.title == "Untitled Document - CODAP"
  puts "Got right document"
else
  puts "Got wrong page"
end

@wait= Selenium::WebDriver::Wait.new(:timeout=>60)

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

@browser.quit

