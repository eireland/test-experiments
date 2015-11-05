require 'rspec'
require 'selenium-webdriver'


def setup
  @browser = Selenium::WebDriver.for :chrome
  @wait= Selenium::WebDriver::Wait.new(:timeout=>30)
  @browser.manage.window.maximize
end

def teardown
  @browser.quit
end

def run
  setup
  yield
  #teardown
end

def getURL(url)
  @browser.get(url)
  puts "Page title is #{@browser.title}"
  #Checks if correct document is on screen
  if @browser.title == "Untitled Document - CODAP"
    puts "Got right document"

  else
    puts "Got wrong page"
  end
end

def testStandAlone(url)
  getURL(url)
  @wait.until{@browser.find_element(:css=>'.focus')}.click
  createNewDocTest
end

def testWithDataInteractive(url)
  getURL(url)
  @wait.until{@browser.find_element(:css=>'.focus')}.click
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
  runPerformanceHarness
end

def testWithDocumentServer(url)
  getURL(url)
  loginAsGuestTest
  @wait.until{@browser.find_element(:css=>'.focus')}.click
  @wait.until {@browser.find_element(:css=> '.dg-graph-button')}.click
  @wait.until {@browser.find_element(:css=> '.dg-tables-button')}.click
  runPerformanceHarness
  loginToolshelfButtonTest
  loginTest
end

def createNewDocTest
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


def loginAsGuestTest
  #Click on Login as Guest button
  sleep(1)
  @loginGuestButton = @wait.until{@browser.find_element(:css=> ".dg-loginguest-button")}
  if @loginGuestButton
    puts "Found Login in as guest button"
    @loginGuestButton.click
  else
    puts "Login as guest button not found"
  end
end


def loginTest
  #Click on Login button
  #@loginButton = @browser.find_element(:xpath, "//label[contains(.,'Login')]")
  @loginButton = @browser.find_element(:css=> ".dg-login-button")
  puts @loginButton
  if @loginButton
    puts "Found Login button"
    @loginButton.click
  else
    puts "Login button not found"
  end
  #<a class="sso-button" href="/users/auth/cc_portal_codap_portal">CODAP Portal</a> for docserver login page.
end


def loginToolshelfButtonTest
  #Click on Login as Guest button
  @loginToolshelfButton = @wait.until{@browser.find_element(:css=> '.dg-toolshelflogin-button')}

  if @loginToolshelfButton
    puts "Found Login button on Toolshelf"
    @loginToolshelfButton.click
    puts "Just clicked the Login on Toolshelf button"
    #  loginTest
  else
    puts "Login button on Toolshelf not found"
  end
end

def runPerformanceHarness

 counter=0
  total_trials=3

  frame = @browser.find_element(:css=> "iframe")

  @browser.switch_to.frame(frame)

  trials = @browser.find_element(:name=>'numTrials')
  trials.clear
  trials.send_keys('20')


  while counter < total_trials do
    counter=counter+1
    run_button_enabled = @wait.until{@browser.find_element(:name=>'run')}
    run_button_enabled.click if run_button_enabled.enabled?


    timeResult=@wait.until{
      timeElement = @browser.find_element(:id=>'time')
      timeElement if timeElement.displayed?
    }
    puts "Time result is #{timeResult.text} ms"
    rateResult=@browser.find_element(:id=>'rate')
    puts "Rate result is #{rateResult.text} cases/sec"
  end

  @browser.switch_to.default_content
end



=begin

run do
  testStandAlone("http://codap.concord.org/releases/latest/static/dg/en/cert/index.html")
end



run do
  testWithDataInteractive("localhost:4020/dg?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end

=end


run do
  testWithDocumentServer("localhost:4020/dg?documentServer=http://document-store.herokuapp.com&di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html")
end


#@url = "http://codap.concord.org/releases/latest/static/dg/en/cert/index.html?documentServer=http://document-store.herokuapp.com/"
#@url="http://codap.concord.org/releases/latest/static/dg/en/cert/index.html?documentServer=http://document-store.herokuapp.com&di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html"
#@url = "http://codap.concord.org/releases/build_0292/static/dg/en/cert/index.html?di=http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html"





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





