#! /usr/bin/ruby
# This script automates Performance Harness. User can specify the browser, CODAP version, number of runs, number of cases, delay between trials.  Results are recorded in a file.
require 'rspec'
require 'selenium-webdriver'
require 'optparse'
require 'date'
require 'csv'

MACBROWSERS = [:firefox, :chrome]
WINBROWSERS = [:firefox, :chrome, :ie]

$test_one=true
$keep_opt={}
def which_test
  puts "test_one is #{$test_one}"
  if $test_one
    opt=parse_args
    $keep_opt=opt
  end
  if !$test_one
    puts "test_one is false. keep_opt is #{$keep_opt}"
    opt=$keep_opt
  end
  return opt
end
#Closes browser at end of test
def teardown
  @browser.quit
end

#Main function
def run
  MACBROWSERS.each do |macbrowser|
    puts macbrowser
    setup(macbrowser, 'mac')
    yield
    teardown
  end
  WINBROWSERS.each do |winbrowser|
    puts winbrowser
    setup(winbrowser, 'win')
    yield
    teardown
  end
end

#Parses the options entered in command line. Syntax is -b = [firefox, chrome]; -v = [build_nnnn], -r = [localhost:4020/dg, codap.concord.org/releases/]
def parse_args
  opt = {}
  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: testLogin.rb [options]"
    opts.separator('')
    opts.on('-v', '--version [BUILDNO]', 'CODAP build number (build_0xxx). Default is latest') do |build|
      opt[:version] = build
    end
    opts.on('-r', '--root_dir [ROOTDIR]', 'Root directory of CODAP. Default is localhost:4020/dg') do |root|
      opt[:root]=root
    end
    opts.on('-t', '--trials [NUMBER OF TRIALS]') do |num_trials|
      opt[:num_trials]=num_trials
    end
    opts.on('-c', '--cases [NUMBER OF CASES]') do |cases|
      opt[:num_cases]=cases
    end
    opts.on('-d', '--delay [DELAY BETWEEN TRIALS (ms)]') do |delay|
      opt[:delay]=delay
    end
    opts.on('-f', '--filename [FILENAME where to save results]','Must be specified if writing to a new file') do |filename|
      opt[:filename]=filename
    end
    opts.on('-p', '--path [PATH where to save results, do not include home in path]') do |path|
      opt[:path]=path
    end
    opts.on('-s', '--sleep [SLEEP time between runs (s)]') do |sleep_time|
      opt[:sleep_time]=sleep_time
    end
    opts.on('-w', '--[no-]write [WRITE]', 'write to a new file-> must specify filename, default is append (no-write). If no file name is specified, results will be appended.') do |write|
      opt[:write]=write
    end

  end
  opt_parser.parse!(ARGV)
  return opt
end

#Writes results from the performance harness to a csv file in the specified directory
def write_to_csv (time, platform, browser_name, browser_version, build, counter, num_cases, delay, duration, rate, test_name)
  googledrive_path="Google Drive/CODAP @ Concord/Software Development/QA"
  localdrive_path="Documents/CODAP data/"

  if !File.exist?("#{Dir.home}/#{$dir_path}/#{$save_filename}") || $new_file
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "wb") do |csv|
      csv<<["Time", "Platform", "Browser", "Browser Version", "CODAP directory", "CODAP Build Num", "Test Name", "Counter", "Num of Cases", "Delay (s)", "Time Result (ms)", "Rate (cases/sec)"]
      csv << [time, platform, browser_name, browser_version, build, $buildno, test_name, counter, num_cases, delay, duration, rate]
    end
  else
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "a") do |csv|
      csv << [time, platform, browser_name, browser_version, build, $buildno, test_name, counter, num_cases, delay, duration, rate]
    end
  end
end

#Sets up default values for the command line options
def setup (browser_name, platform)

  opt=which_test
  #opt = parse_args
  puts "opt is #{opt}"

  if opt[:root].nil?
    opt[:root]="codap.concord.org/releases"
    opt[:version]="latest"
  end
  if opt[:num_trials].nil?
    opt[:num_trials]="1"
  end
  if opt[:num_cases].nil?
    opt[:num_cases]="100"
  end
  if opt[:delay].nil?
    opt[:delay]="1"
  end
  if opt[:filename].nil?
    opt[:filename]="testLoginResultDefault"
  end
  if opt[:path].nil?
    #opt[:path]="Google Drive/CODAP @ Concord/Software Development/QA"
    opt[:path]="Documents/CODAP data/"
  end
  if opt[:sleep_time].nil?
    opt[:sleep_time]="1"
  end
  if opt[:write].nil?
    opt[:write]=false
  end
 puts "platform is #{platform}"
  case platform
    when'mac'
    begin
      @browser = Selenium::WebDriver.for browser_name
    rescue Exception => e
     puts e.message
      puts "Could not start driver"
    end
    when 'win'
      begin
       @browser = Selenium::WebDriver.for(
            :remote,
            :url=> 'http://localhost:4444/wd/hub',
            :desired_capabilities=> browser_name)
      rescue Exception => e
        puts e.message
        puts "Could not start driver #{@browser_name}"
      end
  end

  $ROOT_DIR = opt[:root]
  $dir_path = opt[:path]
  $new_file =opt[:write]

  if opt[:root].include? "localhost"
    $build = "http://#{opt[:root]}"
    $save_filename = "#{opt[:filename]}_localhost.csv"
  else
    if opt[:version].nil?
      opt[:version]="latest"
    end
    $build = "http://#{opt[:root]}/#{opt[:version]}"
    $save_filename = "#{opt[:filename]}_#{opt[:version]}.csv"
  end

  puts $save_filename

  @input_trials = opt[:num_trials]
  @input_cases = opt[:num_cases]
  @input_delay = opt[:delay]
  @input_sleep = opt[:sleep_time]

  @time = (Time.now+1*24*3600).strftime("%m-%d-%Y %H:%M")
 # @platform = @browser.capabilities.platform
 # @browser_name = @browser.capabilities.browser_name
  @browser_version = @browser.capabilities.version
  puts "Time:#{@time}; Platform: #{platform}; Browser: #{browser_name} v.#{@browser_version}; Testing: #{$build}"

  @wait= Selenium::WebDriver::Wait.new(:timeout=>60)
end


#Fetches the website
def get_website(url)
  begin
  @browser.get(url)
  puts "Page title is #{@browser.title}"
  #Checks if correct document is on screen
  if @browser.title == "Untitled Document - CODAP"
    puts "Got right document"
    get_buildno
  end
  rescue Exception =>bad_page
    puts bad_page.message
    puts "Got wrong page"
  end
end

#Gets the build number from the DOM
def get_buildno
  $buildno= @browser.execute_script("return window.DG.BUILD_NUM")
  puts "CODAP build_num is #{$buildno}."
end

#Opens CODAP and creates a new document
def test_standalone(url)
  test_name = "Test Standalone"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  create_new_doc_test
end

#Opens CODAP with specified data interactive in url with graph and table
def test_data_interactive_gt(url)
  test_name = "Test Data Interactive with Graph and Table"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-table-button')}.click
  run_performance_harness(test_name)
end

#Opens CODAP with specified data interactive in url with graph
def test_data_interactive_g(url)
  test_name =  "Test Data Interactive with Graph"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  run_performance_harness(test_name)
  #find_component("Graph")
end

#Opens CODAP with specified data interactive in url with table
def test_data_interactive_t(url)
  test_name = "Test Data Interactive with Table"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  @wait.until {@browser.find_element(:css=> '.dg-table-button')}.click
  run_performance_harness(test_name)
end

#Opens CODAP with specified data interactive in url with no other components
def test_data_interactive(url)
  test_name = "Test Data Interactive"
  puts test_name
  get_website(url)
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  run_performance_harness(test_name)
end

#Opens CODAP with document server, logged in as guest.
def test_document_server(url)
  test_name = "Test Document Server Connection"
  puts test_name
  get_website(url)
  login_as_guest_test
  if @browser.find_element(:css=>'.focus') #Dismisses the splashscreen if present
    @wait.until{@browser.find_element(:css=>'.focus')}.click
  end
  # @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  # @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
  # run_performance_harness(test_name)
  login_toolshelf_button_test
  login_test
end

def create_new_doc_test
  #Send document name to text field
  @wait.until {@browser.find_element(:css=>"input.field")}.send_keys "testDoc"
  @browser.find_element(:css=>"[title='Create a new document with the specified title']").click

  #Validate that the document is created
  if @browser.title.include?("testDoc")
    puts "Created new document"
  else
    puts "Did not create new document"
  end
end


#Clicks on the Login as Guest button in the Login dialog box
def login_as_guest_test
  #Click on Login as Guest button
  sleep(1) #Sleep to slow down when testing on Chrome
  @login_guest_button = @wait.until{@browser.find_element(:css=> ".dg-loginguest-button")}
  if @login_guest_button
    puts "Found Login in as guest button"
    @login_guest_button.click
  else
    puts "Login as guest button not found"
  end
end

#Clicks on the Login button in the Login dialog box
def login_test
  #Click on Login button
  @login_button = @browser.find_element(:css=> ".dg-login-button")
  if @login_button
    puts "Found Login button"
    @login_button.click
  else
    puts "Login button not found"
  end
end


#Clicks on the Login as Guest button in the toolshelf
def login_toolshelf_button_test
  #Click on Login as Guest button
  @login_toolshelf_button = @wait.until{@browser.find_element(:css=> '.dg-toolshelflogin-button')}

  if @login_toolshelf_button
    puts "Found Login button on Toolshelf"
    @login_toolshelf_button.click
    puts "Just clicked the Login on Toolshelf button"
  else
    puts "Login button on Toolshelf not found"
  end
end

#Find the parent component
def find_parent(component)
  parent = component.find_element(:xpath=>'.')
end

#Find the gear menu in a parent component
def find_gear_menu(parent)
  gear_menu=@wait.until{parent.find_element(:css=>'.dg-gear-view')}
  parent_text=parent.text
  gear_menu_parent = find_parent(gear_menu)
  if !gear_menu
    puts "No gear menu"
  else
    gear_menu.click
    puts 'Clicked on gear menu'
    find_gear_menu_item("Show Count")
  end
end

#Find the gear menu item in a parent component
def find_gear_menu_item(menu_item)
  menu_items=@wait.until{@browser.find_elements(:css=>'a.menu-item')}
  menu_item_choice=menu_items.find{|name| name.text==menu_item}
  puts "Menu item name is #{menu_item_choice.text}"
  menu_item_choice.click
end

def find_status(parent)
  puts "In table find_status"
  table_title = @wait.until{parent.find_element(:css=>'.dg-title-view')}
  puts "Table title: #{table_title.text}"

  table_status = @wait.until{parent.find_element(:css=>'div.dg-status-view')}
  puts "Table status: #{table_status.text}"
end

def find_component(component)
  @browser.switch_to.default_content # Always switch to main document when looking for a certain component
  component_views=@browser.find_elements(:css=>'div.component-view')
  component_title=component_views.find{|title| title.find_element(:css=>'div.dg-title-view').text==component}
  puts "Component wanted is #{component}"
  component_title_text = component_title.text
  puts "Component found is #{component_title_text}"
  if component_title!=""
    @parent = find_parent(component_title)
    case component
      when 'Graph'
        find_gear_menu(@parent)
      when 'Performance Harness'
        puts "In Performance Harness"
      #find_gear_menu(@parent)
    end
  end
end

#Run the Performance Harness data interactive
def run_performance_harness(test_name)

  begin
  counter=0
  total_trials=@input_trials.to_i
  num_cases = @input_cases.to_i
  delay = @input_delay.to_i
  sleep_time = @input_sleep.to_i
  total_time = 0
  total_rate = 0
  average_duration = 0
  average_rate = 0

  frame = @browser.find_element(:css=> "iframe")

  @browser.switch_to.frame(frame)

  trials = @browser.find_element(:name=>'numTrials')
  trials.clear
  trials.send_keys(num_cases)
  set_delay = @browser.find_element(:name=>'delay')
  set_delay.clear
  set_delay.send_keys(delay)
  run_button = @wait.until{@browser.find_element(:name=>'run')}

  while counter < total_trials do
    if run_button.enabled?
      sleep(sleep_time)
      run_button.click
      time_result=@wait.until{
        time_element = @browser.find_element(:id=>'time')
        time_element if time_element.displayed?
      }

      rate_result=@wait.until{@browser.find_element(:id=>'rate')}

      duration=time_result.text.to_f
      rate = rate_result.text.to_f
      total_time=total_time+duration
      total_rate = total_rate+rate

      puts "Time:#{@time}, Platform: #{@platform}, Browser: #{@browser_name} v.#{@browser_version}, Testing: #{$build},
            Trial no. #{counter}, Number of cases: #{num_cases}, Delay: #{delay} s, Time result: #{time_result.text} ms, Rate result: #{rate_result.text} cases/sec \n"
      counter=counter+1
      @browser.switch_to.default_content

      @browser.switch_to.frame(frame)
    end

  end

  average_duration = total_time/total_trials
  average_rate = total_rate/total_trials
  puts "Average Duration: #{average_duration}"
  puts "Average Rate: #{average_rate}"
  write_to_csv(@time, @platform, @browser_name, @browser_version, $build, total_trials, num_cases, delay, average_duration, average_rate, test_name)
  @browser.switch_to.default_content
  rescue Exception => e
    puts e.message
    puts "Failed to run Performance Harness"
  end
end

run do
  # test_standalone("#{$build}")
  test_data_interactive("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
  $test_one=false
end

run do
  test_data_interactive_g("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end
run do
  test_data_interactive_t("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end
run do
  test_data_interactive_gt("#{$build}?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end
run do
  test_document_server("#{$build}?documentServer=http://document-store.herokuapp.com&di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end






