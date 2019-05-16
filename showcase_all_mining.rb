#This gets a list of all the presentations in the showcase including ids, keywords, grades, state and audience.
#Run this prior to running showcase_mining.rb to get all the ids of the presentations

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

def write_to_file(video_info)
  $dir_path = "Documents/CODAP data/"
  $save_filename = "Showcase Metadata.csv"

  if !File.exist?("#{Dir.home}/#{$dir_path}/#{$save_filename}") || $new_file
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "wb") do |csv|
      csv<<["Num","State","Level1","Level2", "Level3", "Level4", "Level5", "Level6", "Level7", "Audience1", "Audience2"]
      csv<< video_info
    end
  else
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "a") do |csv|
      csv<< video_info
    end
  end
end



# Get the presenter name and number of views and send them to write to file
def get_info()
  video_array=[]
  max_info_length = 0
  max_video_info_num = ""
  max_video_info = ""
  j=0

  def displayed?(locator)
    puts "looking for #{locator}"
    @driver.find_element(locator)
    puts "#{locator} found"
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "#{locator} not found"
    false
  end

  grid = @wait.until{@driver.find_element(:id,"presentation_grid")}
  # presentation_list = @driver.find_elements(:css, ".isotope > li")
  presentation_list = @driver.find_elements(:css, ".presentation_wrap")

  presentation_list_length = presentation_list.length

    presentation_list.each do |presentation|
    presentation_classes = presentation.attribute("class")
    sep_presentation_classes = presentation_classes.gsub(" ",",")
    video_array.push(sep_presentation_classes)
  end

  while  j<video_array.length
    i=2
    cleaned_video_info=[]
    video_info = video_array[j].split(",") #video_info = ["presentation_wrap", "p_1022", "k_139", "k_145", "g_70", "i_1176", "s_ok", "c_none", "l_grades_k_6", "l_grades_6_8", "l_grades_9_12", "a_researchers", "a_informal_educators", "p_imls", "isotope-item"]
    cleaned_video_info[0]=video_info[1].gsub("p_","").to_i #[1022]
    while i<video_info.length
      if (video_info[i].include? "l_") || (video_info[i].include? "s_") || (video_info[i].include? "a_")
        cleaned_video_info.push((video_info[i][2..-1]))
      end
      i +=1
    end
    video_info_length = cleaned_video_info.length
    if video_info_length > max_info_length
      max_info_length = video_info_length
      max_video_info_num = cleaned_video_info[0]
      max_video_info = cleaned_video_info
    end
    write_to_file(cleaned_video_info)
    j +=1
  end
  puts "Longest info video # #{max_video_info_num}. length of info #{max_info_length} info is #{max_video_info}"
end




def run
  setup
  yield
  teardown
end

run do
  @url_base = "http://stemforall2019.videohall.com/presentations/"
  num_videos = 0

    url = "#{@url_base}"
    get_page(url)
    get_info

end
