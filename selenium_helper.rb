require 'selenium-webdriver'


module SeleniumHelper
  SUPPORTED_BROWSERS = [:Chrome, :Safari, :Firefox, :IE11]
  SUPPORTED_PLATFORMS = [:OSX_10_9, :Win_8_1]
  DEFAULT_PLATFORM = {
      Chrome: :Win_8_1,
      Safari: :OSX_10_9,
      Firefox: :Win_8_1,
      IE11: :Win_8_1
  }
  CLOUD_URL = {
      BrowserStack: 'http://localhost:4444/wd/hub', #Check hub register address before running test
      local: nil
  }

  # Monkey patching, issue described here:
  # https://groups.google.com/forum/#!topic/ruby-capybara/tZi2F306Fvo
  class Selenium::Driver
    def clear_browser
      @browser = nil
    end
  end

  module_function

  def execute_on(browser, platform, cloud, name)
    capybara =
        if cloud != :local
          url = CLOUD_URL[cloud]
          # Each browser has its default platform, however client code can enforce specific one.
          platform ||= DEFAULT_PLATFORM[browser]
          caps = get_capabilities(browser, cloud)
          set_platform(caps, platform, cloud) if platform
          caps['name'] = name
          caps['max-duration'] = 10_800
          Capybara.register_driver :remote_browser do |app|
            Capybara::Selenium::Driver.new(app, browser: :remote, url: url, desired_capabilities: caps)
          end
          Capybara::Session.new(:remote_browser)
        else
          Capybara::Session.new(:selenium)
        end
    driver = capybara.driver.browser
    puts '[webdriver] created'
    # driver.manage.timeouts.implicit_wait = 60
    # driver.manage.timeouts.script_timeout = 300
    # driver.manage.timeouts.page_load = 300
    begin
      yield driver, capybara
    ensure
      puts '[webdriver] quit'
      capybara.driver.quit
      capybara.driver.clear_browser
    end
  end

  def get_capabilities(browser, cloud)
    if  cloud == :BrowserStack
      caps = Selenium::WebDriver::Remote::Capabilities.new
      case browser
        when SUPPORTED_BROWSERS[0]
          caps['browser'] = 'Chrome'
        when SUPPORTED_BROWSERS[1]
          caps['browser'] = 'Safari'
        when SUPPORTED_BROWSERS[2]
          caps['browser'] = 'Firefox'
        when SUPPORTED_BROWSERS[3]
          caps['browser'] = 'IE'
        else
          fail 'Incorrect browser name.'
      end
    else
      fail 'Incorrect cloud name (SauceLabs or BrowserStack expected).'
    end
    caps
  end

  def set_platform(caps, platform, cloud)
    if  cloud == :BrowserStack
      case platform
        when SUPPORTED_PLATFORMS[0]
          caps['os'] = 'OS X'
          caps['os_version'] = 'Mavericks'
        when SUPPORTED_PLATFORMS[1]
          caps['os'] = 'Windows'
          caps['os_version'] = '8.1'
        when SUPPORTED_PLATFORMS[5]
          fail 'Linux is not supported on BrowserStack.'
        else
          fail 'Incorrect platform (OS) name.'
      end
    else
      fail 'Incorrect cloud name (SauceLabs or BrowserStack expected).'
    end
    caps
  end
end

def setupMac(browser_name)
  @driver = Selenium::WebDriver.for browser_name
rescue Exception => e
  puts e.message
  puts "Could not start driver"
  exit 1

end

def setupWin(browser_name)
  @driver = Selenium::WebDriver.for(
      :remote,
      :url=> 'http://localhost:4444/wd/hub',
      :desired_capabilities=> browser_name)
rescue Exception => e
  puts e.message
  puts "Could not start driver #{@browser_name}"
  exit 1
end

def teardown
  puts "in teardown"
  @driver.quit
end

MACBROWSERS = [:firefox, :chrome, :safari]
WINBROWSERS = [:firefox, :chrome, :ie]

def run
  MACBROWSERS.each do |macbrowser|
    puts macbrowser
    setupMac(macbrowser)
    yield
    teardown
  end
  WINBROWSERS.each do |winbrowser|
    puts winbrowser
    setupWin(winbrowser)
    yield
    teardown
  end
end

run do
  @driver.get "http://the-internet.herokuapp.com"
  puts  @driver.capabilities.browser_name
  @browser_name=@driver.capabilities.browser_name

  if @browser_name == "internet explorer"
    puts ("#{@browser_name} inside if statement")
    expect(@driver.title).to eql("WebDriver")
  else
    puts ("#{@browser_name} inside else statement")
    expect(@driver.title).to eql("The Internet")
  end
end

