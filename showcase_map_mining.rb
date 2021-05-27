# have to clean up Singapore rows manually because it is missing a city
require 'rubygems'
require 'selenium-webdriver'
require 'csv'
require 'date'
require 'json'


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

def write_to_file(num, city, state, country, num_visits, num_users, lat, long)
  $dir_path = "Downloads"
  $save_filename = "2021_Showcase_Views_Locations.csv"

  if !File.exist?("#{Dir.home}/#{$dir_path}/#{$save_filename}") || $new_file
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "wb") do |csv|
      csv<<["Date","ID","City", "State","Country", "Num Visits", "Num Users", "lat", "long"]
      csv<< [Date.today,num, city, state, country, num_visits, num_users, lat, long]
    end
  else
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "a") do |csv|
      csv<< [Date.today,num, city, state, country, num_visits, num_users, lat, long]
    end
  end
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

def get_locations(string, id)
  # take the string and split it right before 'var markers'=>
  # and then take the resulting string and remove everything after '];'
  # This should leave you wath the markers variable
  # markers is an array of hashes with {lat,lng, color, zIndex, title}
  # markers.title = "city, state, country - # visits by # users"
  # see showcase_marker_example for an example of what the array looks like
  # puts "string to parse: #{string}"
  temp_cut_1 = string.split('var markers =')
  puts "temp_cut_1: #{temp_cut_1[1]}"
  temp_cut_2 = temp_cut_1[1].split(' // create empty LatLngBounds')
    # puts "temp_cut_2: #{temp_cut_2[0]}"
    temp=temp_cut_2[0].strip
    # puts "strip temp: #{temp}"
    temp = temp.gsub(/[\[\]]/, "")
    location_arr=temp.split("},")
    # puts "location_arr[0]: #{location_arr[0]} location_arr[5000]: #{location_arr[5000]},location_arr length: #{location_arr.length}"
  return location_arr
end

def convert_to_hash(lat, long, city, state, country, visit_num, user_num)
  map={}
  map[:lat]=lat
  map[:long]=long
  map[:city]=city
  map[:state]=state
  map[:country]=country
  map[:visit_num]=visit_num
  map[:user_num]=user_num
  return map
end

def parse_location_array(list)
  location_arr=[]
  list.each do |loc|
      temp_loc=loc.split(',')
      if !temp_loc[0].nil?
        lat_temp = temp_loc[0].split(' ')
        lat = lat_temp[-1]
        # lat=temp_loc[0].strip.sub('{',"").sub('lat:',"").to_f;
      end
      if !temp_loc[1].nil?
        long=temp_loc[1].strip.sub('lng:',"").to_f;
      end
      if !temp_loc[4].nil?
        temp=temp_loc[4].strip.sub('title: "',"").split(' ')
        city = temp[-1]
      end
      if !temp_loc[5].nil?
        state = temp_loc[5].strip;
      end
      if !temp_loc[6].nil?
        country_split=temp_loc[6].split(' - ')
        # country_split = temp_title[0].split(",")
        country = country_split[0]
        if !country_split[1].nil?
          visit_split = country_split[1].split(' ')
          visit_num = visit_split[0].to_f
          user_num = visit_split[3].to_f
        end
      end
      # # puts "loc: :lat=>#{lat}, :long=>#{long}, :city=>#{city}, :state=>#{state}, :country=>#{country}, :visits=>#{visit_num}, :users=>#{user_num}"
      hash=convert_to_hash(lat, long, city, state,country, visit_num, user_num)
      location_arr.push(hash)
  end
  return location_arr
end

def run
  setup
  yield
  teardown
end

run do
  presentations_base_url = "https://stemforall2021.videohall.com/presentations/"
  url_base = "https://stemforall2021.videohall.com/maps"
  location_array = []
  hash_map_arr=[]
  num_videos=0
  presentation_ids = get_presentation_ids(presentations_base_url)
  # presentation_ids = ['1852','1727','1794'] #only the concord projects for now
  presentation_ids.each do |id|
    url = "view-source:#{url_base}/#{id}"
    get_page(url)
    # puts @driver.page_source
    source_string = @driver.page_source
    location_array[num_videos] = get_locations(source_string,id)
    # parse_location_array(location_array[num_videos]).pop
    hash_map_arr = parse_location_array(location_array[num_videos])
    hash_map_arr.pop
    # puts hash_map_arr
    hash_map_arr.each do |hash|
      city = hash[:city]
      state = hash[:state]
      country = hash[:country]
      num_visits = hash[:visit_num]
      num_users = hash[:user_num]
      lat = hash[:lat]
      long = hash[:long]
      write_to_file(id,city, state, country, num_visits, num_users, lat, long)
    end
    num_videos +=1
  end
  puts "num of videos #{num_videos}. Expecting #{num_videos}"
end


# view-source:http://stemforall2018.videohall.com/map/1318
# write_to_file(num, city, state, country, num_visits, num_users, lat, long)