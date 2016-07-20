require './codap_object.rb'
require 'selenium-webdriver'

@@driver = Selenium::WebDriver.for :chrome
ENV['base_url'] = 'http://codap.concord.org/releases/latest/'

codap = CODAPObject.new()
codap.visit
codap.verify_page('CODAP')
codap.dismiss_splashscreen
codap.user_entry_start_new_doc
codap.in_cfm
@@driver.quit