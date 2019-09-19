require 'selenium-webdriver'

module SeleniumHelper
  def self.get_driver
    # ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36'
    #
    # # configure the driver to run in headless mode
    # options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless')
    # options.add_argument("user-agent=#{ua}")  # https://stackoverflow.com/a/29966769
    # driver = Selenium::WebDriver.for(:chrome, options: options)

    #for some reason, adding options won't work anymore, need to figure out a way to add them back in
    driver = Selenium::WebDriver.for :chrome
    return driver
  end

  def self.try_to(attempts = 3, retry_seconds = 1.0)
    (1...attempts).each do
      begin
        return yield
      rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
        puts "#{e.message}"
        sleep(retry_seconds)
      end
    end
    return yield  # raise error on last attempt
  end

  def self.wait_for_load(web_driver, wait)
    begin
      #sleep(0.5)  # retrying is better than hard sleeping
      wait.until do
        web_driver.execute_script('return document.readyState;') == 'complete' && !web_driver.title.empty?
      end
    rescue => ignore
    end
  end

  #added new wait for element method to wait for page to load and display a specific element from the page source
  def self.wait_for_element(web_driver, element)
    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => 20)
      wait.until { web_driver.page_source.include?(element)}
      return true
    rescue Exception => e
      puts "Error waiting for element, #{element.inspect}, to load, message = #{e.inspect}"
      return false
    end
  end


  def self.to_html(web_driver, element)
    return web_driver.execute_script('return JSON.stringify(arguments[0].innerHTML);', element)
  end

  def self.get_wait
    Selenium::WebDriver::Wait.new(timeout: 15, ignore: [Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::StaleElementReferenceError])
  end

  def self.quit_driver(driver)
    driver.quit
  end
end