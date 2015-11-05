#! /usr/bin/ruby
# This script test login to the document server

require 'rspec'
require 'selenium-webdriver'
require 'optparse'
require 'date'
require 'csv'

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
  setup
  yield
#  teardown
end

#Parses the options entered in command line. Syntax is -b = [firefox, chrome]; -v = [build_nnnn], -r = [localhost:4020/dg, codap.concord.org/releases/]
def parse_args
  opt = {}
  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: testLogin.rb [options]"
    opts.separator('')
    opts.on('-b', '--browser [BROWSER]', "Default is Chrome") do |driver|
      opt[:browser] = driver
    end
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
def setup

  opt=which_test
  #opt = parse_args
puts "opt is #{opt}"

  #Set default values
  if opt[:browser].nil?
    opt[:browser]="chrome"
  end
  if opt[:root].nil?
    opt[:root]="localhost:4020/dg"
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
    opt[:path]="Google Drive/CODAP @ Concord/Software Development/QA"
  end
  if opt[:sleep_time].nil?
    opt[:sleep_time]="1"
  end
  if opt[:write].nil?
    opt[:write]=false
  end

  if opt[:browser]=="chrome"
    @browser = Selenium::WebDriver.for :chrome
  elsif opt[:browser]=="firefox"
    @browser = Selenium::WebDriver.for :firefox
  elsif opt[:browser]=='safari'
    @browser = Selenium::WebDriver.for :safari
  elsif opt[:browser]=='ie'
    @browser = Selenium::WebDriver.for :ie
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
  @platform = @browser.capabilities.platform
  @browser_name = @browser.capabilities.browser_name
  @browser_version = @browser.capabilities.version
  puts "Time:#{@time}; Platform: #{@platform}; Browser: #{@browser_name} v.#{@browser_version}; Testing: #{$build}"

  @wait= Selenium::WebDriver::Wait.new(:timeout=>60)
end

#Gets the build number from the DOM
def get_buildno
  $buildno= @browser.execute_script("return window.DG.BUILD_NUM")
  puts "CODAP build_num is #{$buildno}."
end

#Fetches the website
def get_website(url)
  @browser.get(url)
  puts "Page title is #{@browser.title}"
  #Checks if correct document is on screen
  if @browser.title == "Untitled Document - CODAP"
    puts "Got right document"
  else
    puts "Got wrong page"
  end
  get_buildno
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

run do
  test_document_server("#{$build}?documentServer=http://document-store.herokuapp.com&di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end

=begin
  #Click on File icon
  @browser.find_element(:xpath=> "//canvas[@alt='File']").click

  if (@browser.find_element(:xpath=> "//span[contains(.,'Close Document...')]")).displayed?
    puts "Found Close Document"
    @browser.find_element(:xpath=> "//span[contains(.,'Close Document...')]").click
  else
    puts "Close Document not displayed"
  end
=end





