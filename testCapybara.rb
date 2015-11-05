#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'

include Capybara::DSL
Capybara.default_driver= :selenium
@browser = Capybara::Selenium::WebDriver.for :chrome

visit('http://localhost:63342/test%20experiments/testframe.html')
p current_url

fill_in('numTrialsId', :with=>"7")
click_button('Run')