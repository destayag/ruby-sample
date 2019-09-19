class OnsiteInterpretingTestController < ApplicationController
  skip_before_action :verify_authenticity_token 
  
  def index
    @host_urls = PortalTest.get_host_urls
  end

  def perform_onsite_interpreting_test
    @results = {
        'testName': 'View Onsite Interpreting List Test',
        'host': params[:host_url],
        'totalTests': 0,
        'numPassed': 0,
        'numFailed': 0,
        'passed': [],
        'failed': []
    }

    driver = SeleniumHelper.get_driver
    PortalTestHelper.get_onsite_user_types.each do |user_type|
        @results = ApplicationHelper.parse_results(@results, OnsiteInterpretingTest.test_view_onsite_interpretation_list(driver, params[:host_url], user_type))
    end

    SeleniumHelper.quit_driver(driver)
    
    puts @results

    respond_to do |format|
      format.js
    end
  end


  def perform_add_onsite_interpreting_request_test
    @results = {
        'testName': 'Add Onsite Interpreting Request Test',
        'host': params[:host_url],
        'totalTests': 0,
        'numPassed': 0,
        'numFailed': 0,
        'passed': [],
        'failed': []
    }

    driver = SeleniumHelper.get_driver
    PortalTestHelper.get_onsite_user_types.each do |user_type|
        @results = ApplicationHelper.parse_results(@results, OnsiteInterpretingTest.test_add_onsite_interpretation_request(driver, params[:host_url], user_type))
    end

    SeleniumHelper.quit_driver(driver)
    
    puts @results

    respond_to do |format|
      format.js
    end
  end


  def perform_edit_onsite_interpreting_request_test
    @results = {
        'testName': 'Edit Onsite Interpreting Request Test',
        'host': params[:host_url],
        'totalTests': 0,
        'numPassed': 0,
        'numFailed': 0,
        'passed': [],
        'failed': []
    }

    driver = SeleniumHelper.get_driver
    PortalTestHelper.get_onsite_user_types.each do |user_type|
        @results = ApplicationHelper.parse_results(@results, OnsiteInterpretingTest.test_edit_onsite_interpretation_request(driver, params[:host_url], user_type))
    end

    SeleniumHelper.quit_driver(driver)
    
    puts @results

    respond_to do |format|
      format.js
    end
  end



end
