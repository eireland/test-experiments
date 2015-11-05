require 'rubygems'
require 'selenium-webdriver'
require 'rspec'

@browser = Selenium::WebDriver.for(
    :remote,
    :url=> 'http://localhost:4444/wd/hub',
    :desired_capabilities=> :ie)
@wait=Selenium::WebDriver::Wait.new(:timeout=>60)

url = "http://codap.concord.org/releases/latest/??di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html"

def get_website(url)
  @browser.get(url)
  puts "Page title is #{@browser.title}"
  #Checks if correct document is on screen
  if @browser.title == "Untitled Document - CODAP"
    puts "Got right document"
  else
    puts "Got wrong page"
  end
end

#Opens CODAP with specified data interactive in url with no other components
def test_data_interactive(url)
  test_name = "Test Data Interactive"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  run_performance_harness(test_name)
end

#Run the Performance Harness data interactive
def run_performance_harness(test_name)

  counter=0
  total_trials=4
  num_cases = 5
  delay = 1
  sleep_time = 1
  total_time = 0
  total_rate = 0
  average_duration = 0
  average_rate = 0

  frame = @browser.find_element(:css=> "iframe")

  @browser.switch_to.frame(frame)

  trials = @browser.find_element(:name=>'numTrials')
  trials.clear
  trials.send_keys(num_cases)
  set_delay = @browser.find_element(:name=>'delay')
  set_delay.clear
  set_delay.send_keys(delay)
  run_button = @wait.until{@browser.find_element(:name=>'run')}

  while counter < total_trials do
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

=begin
  average_duration = total_time/total_trials
  average_rate = total_rate/total_trials
  puts "Average Duration: #{average_duration}"
  puts "Average Rate: #{average_rate}"
  write_to_csv(@time, @platform, @browser_name, @browser_version, $build, total_trials, num_cases, delay, average_duration, average_rate, test_name)
  @browser.switch_to.default_content
=end

end

  test_data_interactive(url)

@browser.quit