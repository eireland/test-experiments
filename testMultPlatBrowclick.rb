require 'rspec/expectations'
require 'selenium-webdriver'
include RSpec::Matchers

def setupMac(browser_name)
    @driver = Selenium::WebDriver.for browser_name
    @wait= Selenium::WebDriver::Wait.new(:timeout=>30)
  rescue Exception => e
    puts e.message
    puts "Could not start driver"
    exit 1

end

def setupWin(browser_name)
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> browser_name)
  #@wait= Selenium::WebDriver::Wait.new(:timeout=>30)
  rescue Exception => e
    puts e.message
    puts "Could not start driver #{@browser_name}"
    exit 1
end

def teardown
  puts "in teardown"
  @driver.quit
end

MACBROWSERS = [:firefox, :chrome, :safari]
WINBROWSERS = [:firefox, :chrome, :ie]

def run
  MACBROWSERS.each do |macbrowser|
    puts macbrowser
    setupMac(macbrowser)
    yield
    teardown
  end
  WINBROWSERS.each do |winbrowser|
    puts winbrowser
    setupWin(winbrowser)
    yield
    teardown
  end
end

run do
  @driver.get "http://codap.concord.org/~eireland/testframe.html"
  @browser_name=@driver.capabilities.browser_name
  puts @browser_name
  page_title=@driver.title
  puts page_title

  if @browser_name == "internet explorer"
    puts ("#{@browser_name} inside if statement")
    expect(page_title).to eql("TestFrame")#this is sensitive.  Have to check actual title before setting the equality
  else
    puts ("#{@browser_name} inside else statement")
    expect(page_title).to eql("TestFrame")
  end

  numTrials=@driver.find_element(:id=>"numTrialsId")
  numTrials.clear
  numTrials.send_keys("7")
  runButton = @driver.find_element(:name=>"run")
  runButton.click

  logs = @driver.manage.logs.get :chrome
  puts("#{@browser_name} logs #{logs}")
end



