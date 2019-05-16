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

def get_presentation_ids(base_url)
  ids_arr=[]
  get_page(base_url)
  grid = @wait.until{@driver.find_element(:id,"presentation_grid")}
  presentation_list = @driver.find_elements(:css, ".presentation_wrap")

  presentation_list.each do |presentation|
    presentation_id = presentation.attribute("id")
    presentation_id.slice! "p_"
    ids_arr.push(presentation_id)
  end
  return ids_arr
end


def run
  setup
  yield
  teardown
end

run do
  # https://stemforall2019.videohall.com/
  url_base = "https://stemforall2019.videohall.com/presentations"

  num_videos=0
  presentation_ids = get_presentation_ids(url_base)
  
  presentation_ids.each do |id|
    url = "view-source:#{url_base}/presentations/#{id}"
    get_page(url_base)
  puts @driver.page_source
  temp = @driver.page_source
    get_info(id,url)
    num_videos +=1
  end
  puts "num of videos #{num_videos}. Expecting 242"
end


# view-source:http://stemforall2018.videohall.com/map/1318