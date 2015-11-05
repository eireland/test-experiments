require 'rubygems'
require 'selenium-webdriver'
require 'rspec'

@browser = Selenium::WebDriver.for(
    :remote,
    :url=> 'http://localhost:4444/wd/hub',
    :desired_capabilities=> :ie)
url = "http://codap.concord.org/~eireland/testframe.html"

@browser.get(url)
puts "Page title is #{@browser.title}"
#Checks if correct document is on screen
if @browser.title == "TestFrame"
  puts "Got right document"
else
  puts "Got wrong page"
end

@browser.find_element(:id=>"numTrialsId").send_keys("9")
@browser.find_element(:name=>"run").click

@browser.quit