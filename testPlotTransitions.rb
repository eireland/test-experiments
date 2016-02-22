require 'selenium-webdriver'
require 'rspec/expectations'
require './codap_object'
include RSpec::Matchers
require './LogReporter'

def setupHelper(session_id)
  @logger = LogReporter.new(session_id)
end

def write_result_file(doc_name)
  googledrive_path="Google Drive/CODAP @ Concord/Software Development/QA"
  localdrive_path="Documents/CODAP data/"
  $dir_path = "Documents/CODAP data/"
  $save_filename = "Plot_changes_logs"

  log = @driver.manage.logs.get(:browser)
  messages = ""
  log.each {|item| messages += item.message + "\n"}

  if !File.exist?("#{Dir.home}/#{$dir_path}/#{$save_filename}") || $new_file
    File.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "wb") do |log|
      log<< messages unless messages == ""
    end
  else
    File.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "a") do |log|
      log << messages unless messages == ""
    end
  end

end

def setup(browser_name)
  caps = Selenium::WebDriver::Remote::Capabilities.new
  case (browser_name)
    when :firefox
      caps[:browserName] = :firefox
      caps[:logging_prefs] = {:browser => "ALL"}
    when :chrome
      caps[:browserName] = :chrome
      caps[:logging_prefs] = {:browser => "ALL"}
    when :safari
      caps[:browserName] = :safari
      caps[:logging_prefs] = {:browser => "ALL"}
  end
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> caps )
  setupHelper(@driver.session_id)
  ENV['base_url'] = 'http://codap.concord.org/releases/latest/'
  #ENV['base_url'] = 'http://codap.concord.org/~eireland/CodapClasses'
  #ENV['base_url'] = 'localhost:4020/dg'
  dnd_javascript = File.read(Dir.pwd + '/dnd.js')
rescue Exception => e
  puts e.message
  puts "Could not start driver #{@browser_name}"
  exit 1
end

def teardown
  puts "in teardown"
  @driver.quit
end

MACBROWSERS = [:chrome]

def run
  MACBROWSERS.each do |macbrowser|
    puts macbrowser
    setup(macbrowser)
    yield
    #teardown
  end
end

run do
  codap = CODAPObject.new(@driver)
  open_doc = '3TableGroups.json'
  file = File.absolute_path(File.join(Dir.pwd, open_doc))
  puts "file is #{file}, open_doc is #{open_doc}"
  codap.open_local_doc(file)
  open_doc.slice! '.json'
  codap.verify_doc(open_doc)
  #codap.click_table_button
  codap.click_graph_button
  codap.drag_attribute('ACAT1','x')
  write_result_file(open_doc)
  codap.drag_attribute('ACAT2','y')
  write_result_file(open_doc)
  codap.drag_attribute('ANUM1','x')
  write_result_file(open_doc)
  codap.drag_attribute('ANUM2','y')
  write_result_file(open_doc)
  codap.drag_attribute('BCAT1','x')
  write_result_file(open_doc)
  codap.drag_attribute('BNUM1','x')
  write_result_file(open_doc)
  codap.drag_attribute('CCAT1','x')
  write_result_file(open_doc)
  codap.drag_attribute('CNUM1','x')
  write_result_file(open_doc)
  codap.drag_attribute('BNUM1','y')
  write_result_file(open_doc)
  codap.drag_attribute('CCAT2','x')
  write_result_file(open_doc)
  codap.drag_attribute('BCAT1','y')
  write_result_file(open_doc)
  codap.drag_attribute('ACAT2','y')
  write_result_file(open_doc)
  codap.drag_attribute('BCAT1','legend')
  write_result_file(open_doc)
  codap.drag_attribute('CNUM1','legend')
  write_result_file(open_doc)
  #puts @logger.latest
end