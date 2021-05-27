# run showcase_all_mining.rb first to get all the presentation ids
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

def write_to_file(num, presenter, presenter_org, presentations, grant_1, grant_2, grant_3, views, discussions, keyword_1, keyword_2, keyword_3, url)
  $dir_path = "Downloads"
  $save_filename = "2021_Showcase_Views.csv"
  puts "in write_to_file"
  if !File.exist?("#{Dir.home}/#{$dir_path}/#{$save_filename}") || $new_file
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "wb") do |csv|
      csv<<["Date","ID","Presenter","Organization","Presentation","Grant_1","Grant_2", "Grant_3", "Views", "Discussions", "Keyword_1", "Keyword_2", "Keyword_3", "URL"]
      csv<< [Date.today,num, presenter, presenter_org, presentations, grant_1, grant_2, grant_3, views, discussions, keyword_1, keyword_2, keyword_3, url]
    end
  else
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "a") do |csv|
      csv<< [Date.today,num, presenter, presenter_org, presentations, grant_1, grant_2, grant_3, views, discussions, keyword_1, keyword_2, keyword_3, url]
    end
  end
end

# Get all the presentation ids from the grid view of the presentations and return an array of ids
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

# Get the presenter name and number of views and send them to write to file
def get_info(i, url)

  def displayed?(locator)
    locs=[]
    locs = @driver.find_elements(:css,locator)
    if locs.length>0
      return true
    else
      return false
    end
  end
  puts i
  presentation = @driver.title

  # presenter name locators are not consistent from page to page so have to check which locator to use to get presenter name
  if displayed?("#gallery > div.ad-image-wrapper > div.ad-image > div.ad-image-description > h2 > a")
    presenter_locator = @driver.find_element(:css,"#gallery > div.ad-image-wrapper > div.ad-image > div.ad-image-description > h2 > a")
  elsif displayed? ("#content_responsive > div.content_grey > div > div:nth-child(1) > div.presenter_col.col-sm-5.col-md-3 > div.presenter_meta > div.member_info > h2 > a")
    presenter_locator = @driver.find_element(:css, "#content_responsive > div.content_grey > div > div:nth-child(1) > div.presenter_col.col-sm-5.col-md-3 > div.presenter_meta > div.member_info > h2 > a")
  elsif displayed?("#gallery > div.ad-image-wrapper > div.ad-image > div.ad-image-description > h2")
    presenter_locator = @driver.find_element(:css,"#gallery > div.ad-image-wrapper > div.ad-image > div.ad-image-description > h2")
  else
    presenter_locator = @driver.find_element(:css, "#content_responsive > div.content_grey > div > div:nth-child(1) > div.presenter_col.col-sm-5.col-md-3 > div.presenter_meta > div.member_info > h2")
  end
  presenter = presenter_locator.text

  presenter_organization = @driver.find_element(:css,".presenter").text

  views_locator = @driver.find_element(:css, "#content_responsive > div.content_grey > div > div:nth-child(2) > div.col-sm-12.col-md-3.hidden-xs.hidden-sm > div.social_panel > div > div:nth-child(1) > h3")
  views = views_locator.text

# NSF grans are links while non-NSF grants are not links. The first condition finds all the grants the are links. The second just finds the p element with the list of non-link grants and returns them as one unit.
  if displayed? ("#abstract_scroll > p:nth-child(2) > a")
    grant_list = @wait.until{@driver.find_elements(css: "#abstract_scroll > p:nth-child(2) > a")}
    has_link=true
    grant_list_length = grant_list.length
  else
    grant_list = @wait.until{@driver.find_element(css: "#abstract_scroll > p:nth-child(2)" )}
    grant_list_length = 1
  end
  # puts "grant_list is #{grant_list}. grant_list_length is #{grant_list_length}"


  if has_link #checks to see if the grants are links and gets each text individually. Otherwise return the enter p element regardless of how many grants there are
    case grant_list_length
      when 1
        grant_1 = @wait.until{@driver.find_element(:css, "#abstract_scroll > p:nth-child(2) > a").text} #abstract_scroll > p:nth-child(2) > a
        grant_2 = ""
        grant_3 = ""
      when 2
        grant_1 = @wait.until{@driver.find_element(:css, "#abstract_scroll > p:nth-child(2) > a:nth-child(1)").text}
        grant_2 = @wait.until{@driver.find_element(:css, "#abstract_scroll > p:nth-child(2) > a:nth-child(2)").text}
        grant_3 = ""
      when 3
        grant_1 = @wait.until{@driver.find_element(:css, "#abstract_scroll > p:nth-child(2) > a:nth-child(1)").text}
        grant_2 = @wait.until{@driver.find_element(:css, "#abstract_scroll > p:nth-child(2) > a:nth-child(2)").text}
        grant_3 = @wait.until{@driver.find_element(:css, "#abstract_scroll > p:nth-child(2) > a:nth-child(3)").text}
    end
  else grant_1 = @wait.until{@driver.find_element(css: "#abstract_scroll > p:nth-child(2)" ).text}
  end

  discussions = @wait.until{@driver.find_element(:css, "#panel-mc-count").text.tr('()','').to_i}
  kw_list=@wait.until{@driver.find_elements(:css, ".kw")}
  kw_list_length = kw_list.length
  kw_first = 2
  # puts "ks_list_length is #{kw_list_length}"

   case kw_list_length
     when 1
       keyword_1 = @wait.until{@driver.find_element(:css, "#panel_video > div.presentation_extra > a:nth-child(2)").text}
       keyword_2 = ""
       keyword_3 = ""
     when 2
       keyword_1 = @wait.until{@driver.find_element(:css, "#panel_video > div.presentation_extra > a:nth-child(2)").text}
       keyword_2 = @wait.until{@driver.find_element(:css, "#panel_video > div.presentation_extra > a:nth-child(3)").text}
       keyword_3 = ""
     when 3
       keyword_1 = @wait.until{@driver.find_element(:css, "#panel_video > div.presentation_extra > a:nth-child(2)").text}
       keyword_2 = @wait.until{@driver.find_element(:css, "#panel_video > div.presentation_extra > a:nth-child(3)").text}
       keyword_3 = @wait.until{@driver.find_element(:css, "#panel_video > div.presentation_extra > a:nth-child(4)").text}
   end

  puts "Presentation is #{presentation}, Grant_1 is #{grant_1}, Grant_2 is #{grant_2}, Grant_3 is #{grant_3}, Num Views is #{views}, Discussions is #{discussions}, Keyword_1: #{keyword_1}, Keyword_2: #{keyword_2}, Keyword_3: #{keyword_3}, url is #{url}"
  view_num = views.to_i
  write_to_file(i,presenter, presenter_organization, presentation, grant_1, grant_2, grant_3, view_num, discussions, keyword_1,keyword_2, keyword_3, url)
end




def run
  setup
  yield
  teardown
end

run do
  url_base = "https://stemforall2021.videohall.com/presentations/"
  num_videos=0
  presentation_ids = get_presentation_ids(url_base)

  presentation_ids.each do |id|
    url = "#{url_base}/#{id}"
    get_page(url)
    get_info(id,url)
    num_videos +=1
    puts "This is video #{num_videos}"
  end
  puts "num of videos #{num_videos}. Expecting 171"
end
