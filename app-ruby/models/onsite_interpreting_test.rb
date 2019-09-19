class OnsiteInterpretingTest < ApplicationRecord

  def self.test_view_onsite_interpretation_list(driver, env, user_type)
    puts "#{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}onsite_interpretings",driver,user_type)
    puts "onsite_user = #{user_type.inspect}"

    permission = PortalTestHelper.get_user_permissions(user_type)
    puts "permission = #{permission.inspect}"

    # checking is user has no permission, going directly to the Onsite Interpreting Page shows the Not Authorized error!
    if permission[:pages][:OnsiteInterpreting] == ''
      puts "User has no permission to view Onsite Interpreting"
      SeleniumHelper.wait_for_element(driver, "Not Authorized!")
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "User --> #{user_type} has no permission to view Onsite Interpreting"}
    end

    # TODO: handle F, FE, FA, and WA permissions
    if permission[:pages][:OnsiteInterpreting] == 'WE' || permission[:pages][:OnsiteInterpreting] == 'W' || permission[:pages][:OnsiteInterpreting] == 'R' and permission[:multiple_services] == true
      puts "Clicking View button of an Onsite Interpreting Service"
      SeleniumHelper.wait_for_element(driver, "Company Services")
      sleep 2
      driver.find_element(:link, 'View').click 
      SeleniumHelper.wait_for_element(driver, "On-Site Interpreting")
      sleep 2
      helper_results = OnsiteInterpretingTestHelper.view_onsite_list(user_type, driver)   
      puts "Return #{helper_results}."
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Return #{helper_results}. Test Passed for View of Onsite Interpreting List for #{user_type} with two company"} if helper_results
      return {passed: false, name: "Return #{helper_results}. Test Failed for View of Onsite Interpreting List for #{user_type} with two company"} if !helper_results   
    end   

    # TODO: handle F, FE, FA, and WA permissions
    if permission[:pages][:OnsiteInterpreting] == 'WE' || permission[:pages][:OnsiteInterpreting] == 'W' || permission[:pages][:OnsiteInterpreting] == 'R' and permission[:multiple_services] == false
      SeleniumHelper.wait_for_element(driver, "Onsite Interpreting")
      sleep 2
      helper_results = OnsiteInterpretingTestHelper.view_onsite_list(user_type, driver)    
      puts "Return #{helper_results}."
      PortalTestHelper.logout("#{env}",driver,user_type) 
      return {passed: true, name: "Return #{helper_results}. Test Passed for View of Onsite Interpreting List for #{user_type} with one company"} if helper_results
      return {passed: false, name: "Return #{helper_results}. Test Failed for View of Onsite Interpreting List for #{user_type} with one company"} if !helper_results
    end   
  end


  def self.test_add_onsite_interpretation_request(driver, env, user_type)
    puts "#{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}onsite_interpretings",driver,user_type)
    puts "onsite_user = #{user_type.inspect}"

    permission = PortalTestHelper.get_user_permissions(user_type)
    puts "permission = #{permission.inspect}"

    # checking is user has no permission, going directly to the Onsite Interpreting Page shows the Not Authorized error!
    if permission[:pages][:OnsiteInterpreting] == ''
      puts "User has no permission to view Onsite Interpreting"
      SeleniumHelper.wait_for_element(driver, "Not Authorized!")
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "User --> #{user_type} has no permission to view Onsite Interpreting"}
    end

    # checking if Add button is displayed for user with R, RA, RE permissions
    if permission[:pages][:OnsiteInterpreting] == 'R' || permission[:pages][:OnsiteInterpreting] == 'RA' || permission[:pages][:OnsiteInterpreting] == 'RE' and permission[:multiple_services] == false
      puts "Checking for add button if displayed"
      if driver.find_elements(:link, 'Add On-Site Appointment').size > 0
        puts "User with read only or no permission don't have the access to add onsite request"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Test Failed. User with read only or no permission don't have the access to add onsite request"}    
      else
        puts "Test Passed on any onsite users that has only read permission"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Test Passed. User with read only or no permission don't have the access to add onsite request"}
      end
    end

    # TODO: Need to account for F, FE, FA and WA permissions
    if permission[:pages][:OnsiteInterpreting] == 'WE' || permission[:pages][:OnsiteInterpreting] == 'W' and permission[:multiple_services] == true
      puts "Clicking View button of an Onsite Interpreting Service"
      SeleniumHelper.wait_for_element(driver, "Company Services")
      sleep 2
      driver.find_element(:link, 'View').click 
      sleep 2
      SeleniumHelper.wait_for_element(driver, "On-Site Interpreting")
      sleep 2
      # tapping add onsite requests
      puts "Clicking Add On-Site Appointment button"
      driver.find_element(:link, 'Add On-Site Appointment').click   
      sleep 1         
      helper_results = OnsiteInterpretingTestHelper.add_onsite_request(user_type, driver)   
      # end of tests
      puts "Test Passed for adding onsite request on any onsite users with two companies"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Test Passed for Adding Onsite Interpreter Request for #{user_type} with two companies"} if helper_results
      return {passed: false, name: "Test Failed for Adding an Onsite Interpreter Request for #{user_type} with two companies"} if !helper_results   
    end

    # TODO: Need to account for F, FE, FA and WA permissions
    if permission[:pages][:OnsiteInterpreting] == 'WE' || permission[:pages][:OnsiteInterpreting] == 'W' and permission[:multiple_services] == false    
      puts "Test for creating an onsite request for a company user"
      SeleniumHelper.wait_for_element(driver, "Onsite Interpreting")
      sleep 2
      # tapping add onsite requests
      puts "Clicking Add On-Site Appointment button"
      driver.find_element(:link, 'Add On-Site Appointment').click   
      sleep 1      
      helper_results = OnsiteInterpretingTestHelper.add_onsite_request(user_type, driver)    
      # end of tests
      puts "Test Passed for adding onsite request on any onsite users with one company"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Test Passed for Adding an Onsite Interpreting Request for #{user_type} with one company"} if helper_results   
      return {passed: false, name: "Test Failed for Adding an Onsite Interpreting Request for #{user_type} with one company"} if !helper_results  
    end      
  end 


  #test for editing an onsite request
  def self.test_edit_onsite_interpretation_request(driver, env, user_type)
    puts "#{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}onsite_interpretings",driver,user_type)
    puts "onsite_user = #{user_type.inspect}"

    permission = PortalTestHelper.get_user_permissions(user_type)
    puts "permission = #{permission.inspect}"
    # checking is user has no permission, going directly to the Onsite Interpreting Page shows the Not Authorized error!
    if permission[:pages][:OnsiteInterpreting] == ''
      puts "User has no permission to view Onsite Interpreting"
      SeleniumHelper.wait_for_element(driver, "Not Authorized!")
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "User --> #{user_type} has no permission to view Onsite Interpreting"}
    end

    # checking if Add button is displayed for user with R, RA, RE permissions
    if permission[:pages][:OnsiteInterpreting] == 'R' || permission[:pages][:OnsiteInterpreting] == 'RA' || permission[:pages][:OnsiteInterpreting] == 'RE' and permission[:multiple_services] == false
      puts "Checking for add button if displayed"
      if driver.find_elements(:link, 'Edit').size > 0 ||  driver.find_elements(:link, 'Cancel').size > 0 
        puts "User with read only or no permission don't have the access to edit and cancel buttons on onsite Interpreting"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Test Failed. User with read only or no permission don't have the access to edit and cancel buttons on onsite Interpreting"}    
      else
        puts "Test Passed on any onsite users that has only read permission"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Test Passed. User with read only or no permission don't have the access to edit and cancel buttons on onsite Interpreting"}
      end
    end

    # TODO: Need to account for F, FE, FA and WA permissions
    if permission[:pages][:OnsiteInterpreting] == 'WE' || permission[:pages][:OnsiteInterpreting] == 'W' and permission[:multiple_services] == true
      puts "Clicking View button of an Onsite Interpreting Service"
      SeleniumHelper.wait_for_element(driver, "Company Services")
      sleep 2
      driver.find_element(:link, 'View').click 
      SeleniumHelper.wait_for_element(driver, "On-Site Interpreting")
      sleep 2
      # tapping detail onsite requests
      puts "Clicking Details button"
      driver.find_element(:link, 'Details').click   
      SeleniumHelper.wait_for_element(driver, "Edit")
      # tapping edit onsite requests
      puts "Clicking Edit button"
      driver.find_element(:link, 'Edit').click   
      sleep 1
      helper_results = OnsiteInterpretingTestHelper.edit_onsite_request(user_type, driver)
      # end of tests
      puts "Return = #{helper_results}. Test Passed for editing onsite request on any onsite users with two companies."
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Test Passed for Editing an Onsite Interpreter Request for #{user_type} with two companies"} if helper_results
      return {passed: false, name: "Test Failed for Editing an Onsite Interpreter Request for #{user_type} with two companies"} if !helper_results
    end

    # TODO: Need to account for F, FE, FA and WA permissions
    if permission[:pages][:OnsiteInterpreting] == 'WE' || permission[:pages][:OnsiteInterpreting] == 'W' and permission[:multiple_services] == false    
      puts "Test for editing an onsite request for a company user"
      SeleniumHelper.wait_for_element(driver, "Onsite Interpreting")
      sleep 2
      # tapping detail onsite requests
      puts "Clicking Details button"
      driver.find_element(:link, 'Details').click   
      SeleniumHelper.wait_for_element(driver, "Edit")
      # tapping edit onsite requests
      puts "Clicking Edit button"
      driver.find_element(:link, 'Edit').click   
      sleep 1
      helper_results = OnsiteInterpretingTestHelper.edit_onsite_request(user_type, driver)
      # end of tests
      puts "Return = #{helper_results}. Test Passed for editing onsite request on any onsite users with one company"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Test Passed for Editing an Onsite Interpreting Request for #{user_type} for one company"} if helper_results 
      return {passed: false, name: "Test Failed for Editing an Onsite Interpreting Request for #{user_type} for one company"} if !helper_results 
    end
  end

end