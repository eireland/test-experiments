class PerformanceHarnessObject

    SPLASHSCREEN = {css: '.focus'}
    DATA_INTERACTIVE = { css: 'iframe'    }
    NUM_TRIALS_FIELD = { name: 'numTrials' }
    DELAY_FIELD = { name: 'delay'  }
    RUN_BUTTON = {name: 'run'}
    TIME_ELEMENT = {id: 'time' }
    RATE_ELEMENT = {id: 'rate' }


    attr_reader :driver

    def initialize(driver)
      @driver = driver
      visit
      verify_page
      dismiss_splashscreen
      switch_to_iframe
    end

    def visit
      driver.get ENV['base_url']
    end

    def switch_to_iframe
      iframe=driver.find_element(DATA_INTERACTIVE)
      driver.switch_to.frame(iframe)
    end

    def start_sim(num_trials, delay)
      sleep_time = 1
      driver.find_element(NUM_TRIALS_FIELD).clear
      driver.find_element(NUM_TRIALS_FIELD).send_keys num_trials
      driver.find_element(DELAY_FIELD).clear
      driver.find_element(DELAY_FIELD).send_keys delay
      run_button = driver.find_element(RUN_BUTTON)
      if run_button.enabled?
        sleep(sleep_time)
        driver.find_element(RUN_BUTTON).click
      end
    end

    def status_result_present?(status_result)
      wait_for { displayed?(TIME_ELEMENT) }
      status_result_time = driver.find_element(TIME_ELEMENT)
      wait_for { displayed?(RATE_ELEMENT)}
      status_result_rate = driver.find_element(RATE_ELEMENT)
      true
    end

    def get_time_result(time_result)
      wait_for { displayed?(TIME_ELEMENT) }
      time_result = driver.find_element(TIME_ELEMENT).text.to_f
    end

    def get_rate_result(rate_result)
      wait_for { displayed?(RATE_ELEMENT)}
      rate_result = driver.find_element(RATE_ELEMENT).text.to_f
    end

    private

    def verify_page
      expect(driver.title).to eql('Untitled Document - CODAP')
    end

    def dismiss_splashscreen
      if driver.find_element(SPLASHSCREEN) #Dismisses the splashscreen if present
         driver.find_element(SPLASHSCREEN).click
      end
    end

    def wait_for(seconds=5)
      Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
    end

    def displayed?(locator)
      driver.find_element(locator).displayed?
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
    end


end