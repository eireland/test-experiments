require 'rubygems'
require 'selenium-webdriver'
require 'csv'
require 'date'


def setup
  @driver = Selenium::WebDriver.for :chrome
  @wait= Selenium::WebDriver::Wait.new(:timeout=>25)
  target_size = Selenium::WebDriver::Dimension.new(1680,1050)
  @driver.manage.window.size = target_size
end

def teardown
  puts "in teardown"
  @driver.quit
end

def get_page(url)
  @driver.get url
end


def run
  setup
  yield
  teardown
end

run do
  url_base = "view-source:http://stemforall2018.videohall.com/map/1318"
  # num_videos=0
  # presentation_ids = get_presentation_ids(url_base)
  #
  # presentation_ids.each do |id|
  #   url = "#{url_base}/#{id}"
    get_page(url_base)
  #   get_info(id,url)
  #   num_videos +=1
  # end
  # puts "num of videos #{num_videos}. Expecting 214"
end


# view-source:http://stemforall2018.videohall.com/map/1318