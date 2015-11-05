require 'rubygems'
require 'selenium-webdriver'
require 'rspec'

@browser = Selenium::WebDriver.for :firefox
url = "http://the-internet.herokuapp.com/"

  @browser.get(url)
  puts "Page title is #{@browser.title}"
  #Checks if correct document is on screen
  if @browser.title == "The Internet"
    puts "Got right document"
  else
    puts "Got wrong page"
  end

@browser.quit