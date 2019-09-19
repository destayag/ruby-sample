class UserSessionTestController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @host_urls = PortalTest.get_host_urls
  end

  def perform_login_test

    @results = {
        'testName': 'Simple login test',
        'host': params[:host_url],
        'totalTests': 0,
        'numPassed': 0,
        'numFailed': 0,
        'passed': [],
        'failed': []
    }

    driver = SeleniumHelper.get_driver
 
    #test successful simple login
    PortalTestHelper.get_user_types.each do |user_type|
        #test successful simple login    
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.test_simple_login(driver, params[:host_url], user_type))
        # test invalid login 1(invalid password)
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.invalid_login_test1(driver, params[:host_url], user_type))
        #Test for invalid login test 2: Invalid Email
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.invalid_login_test2(driver, params[:host_url], user_type))
        #Test for invalid login test 3: Invalid Email and Password
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.invalid_login_test3(driver, params[:host_url], user_type))
    end

    # Quit Selenium Driver
    SeleniumHelper.quit_driver(driver)

    # Display Results
    puts @results

    respond_to do |format|
      format.js
    end
  end


  def perform_basic_user_info_test

    @results = {
        'testName': 'Basic user info test',
        'host': params[:host_url],
        'totalTests': 0,
        'numPassed': 0,
        'numFailed': 0,
        'passed': [],
        'failed': []
    }

    driver = SeleniumHelper.get_driver
    PortalTestHelper.get_user_types.each do |user_type|
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.change_first_name(driver, params[:host_url], user_type))
        #added changes for last name
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.change_last_name(driver, params[:host_url], user_type))
        #added changes for the gender
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.change_gender(driver, params[:host_url], user_type))
        #added changes for the timezone
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.change_timezone(driver, params[:host_url], user_type))
    end

    SeleniumHelper.quit_driver(driver)
    
    puts @results

    respond_to do |format|
      format.js
    end
  end

  def perform_profile_department_test
      @results = {
        'testName': 'Department tests',
        'host': params[:host_url],
        'totalTests': 0,
        'numPassed': 0,
        'numFailed': 0,
        'passed': [],
        'failed': []
    }

    # Scenario for add, remove, and test department exists
    driver = SeleniumHelper.get_driver
    PortalTestHelper.get_user_types.each do |user_type|
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.adding_department_to_user(driver, params[:host_url], user_type))
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.remove_department(driver, params[:host_url], user_type))
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.department_existence(driver, params[:host_url], user_type))
    end

    SeleniumHelper.quit_driver(driver)
    
    puts @results

    respond_to do |format|
      format.js
    end

  end


  def perform_change_address_test
      @results = {
      'testName': 'User Change Address test',
      'host': params[:host_url],
      'totalTests': 0,
      'numPassed': 0,
      'numFailed': 0,
      'passed': [],
      'failed': []
      }

      driver = SeleniumHelper.get_driver

      PortalTestHelper.get_user_types.each do |user_type|
          #change address test
          @results = ApplicationHelper.parse_results(@results, UserSessionTest.change_address_test(driver, params[:host_url], user_type))
          #add address test
          @results = ApplicationHelper.parse_results(@results, UserSessionTest.add_address_test(driver, params[:host_url], user_type))
      end

      SeleniumHelper.quit_driver(driver)

      puts @results

      respond_to do |format|
        format.js
      end
  end

  def perform_reset_password_test
      @results = {
      'testName': 'User Reset Password Test',
      'host': params[:host_url],
      'totalTests': 0,
      'numPassed': 0,
      'numFailed': 0,
      'passed': [],
      'failed': []
      }

      #Test for Reset Password
      driver = SeleniumHelper.get_driver
      PortalTestHelper.get_password_user_types.each do |user_type|
          @results = ApplicationHelper.parse_results(@results, UserSessionTest.reset_password_test(driver, params[:host_url], user_type))
          @results = ApplicationHelper.parse_results(@results, UserSessionTest.new_password_doesnt_meet_conditions(driver, params[:host_url], user_type))
          @results = ApplicationHelper.parse_results(@results, UserSessionTest.incorrect_password_confirmation(driver, params[:host_url], user_type))
          @results = ApplicationHelper.parse_results(@results, UserSessionTest.incorrect_current_password(driver, params[:host_url], user_type))
          @results = ApplicationHelper.parse_results(@results, UserSessionTest.enter_previous_password(driver, params[:host_url], user_type))
      end


      SeleniumHelper.quit_driver(driver)

      puts @results

      respond_to do |format|
        format.js
      end
  end

  def perform_permission_test
      @results = {
      'testName': 'User Permission Test',
      'host': params[:host_url],
      'totalTests': 0,
      'numPassed': 0,
      'numFailed': 0,
      'passed': [],
      'failed': []
      }

      driver = SeleniumHelper.get_driver
      PortalTestHelper.get_user_types.each do |user_type|
        PortalTestHelper.get_pages.each do |page|
          @results = ApplicationHelper.parse_results(@results, UserSessionTest.test_page_permissions(driver, params[:host_url], user_type, page))
        end
      end

      SeleniumHelper.quit_driver(driver)

      puts @results

      respond_to do |format|
        format.js
      end
  end

  def perform_permission_test_unauthorized_pages
    @results = {
        'testName': 'User Permission Unauthorized Pages Test',
        'host': params[:host_url],
        'totalTests': 0,
        'numPassed': 0,
        'numFailed': 0,
        'passed': [],
        'failed': []
    }

    #Test for User Permission - Side Navigation - Unauthorized pages test
    driver = SeleniumHelper.get_driver
    PortalTestHelper.get_user_types.each do |user_type|
      PortalTestHelper.get_pages.each do |page|
        @results = ApplicationHelper.parse_results(@results, UserSessionTest.test_unauthorized_page_permissions(driver, params[:host_url], user_type, page))
      end
    end

    SeleniumHelper.quit_driver(driver)

    puts @results

    respond_to do |format|
      format.js
    end
  end

end
