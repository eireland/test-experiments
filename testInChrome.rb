require 'rubygems'
require 'selenium-webdriver'

counter=1
totalTrials=5
continue=false
runButtonClicked=false

driver = Selenium::WebDriver.for :chrome
driver.get "http://localhost:4020/dg?moreGames=[{%22name%22:%22PerformanceHarness%22,%22dimensions%22:{%22width%22:550,%22height%22:500},%22url%22:%22http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html%22}]&componentMode=yes"

puts "Page title is #{driver.title}"

wait= Selenium::WebDriver::Wait.new(:timeout=>60)

frame = driver.find_element(:css, "iframe")

driver.switch_to.frame(frame)

trials = driver.find_element(:name=>'numTrials')
trials.clear
trials.send_keys('200')

for counter in 1..totalTrials

  wait.until do
    runButton = driver.find_element(:name=>'run')
      runButton.click if runButton.enabled?

    if runButton.enabled?
      wait.until do
        timeElement = driver.find_element(:id=>'time')
        if timeElement.text!=""
          puts "#{counter}. Time is #{timeElement.text}"
          rateResult=driver.find_element(:id=>'rate')
          puts "  Rate result is #{rateResult.text} cases/sec"
          counter=counter+1
        end
      end
    end
  end
end
#driver.quit