class UserSessionTest < ApplicationRecord


  def self.test_simple_login(driver, url="https://portal.dev.helloglobo.com", user_type)
    #Test for simple login
    driver = driver || SeleniumHelper.get_driver #uses the passed in driver or gets it from selenium
    driver.navigate.to(url) #defaults to staging, make sure to add the rest of the sign in url

    puts "Start of logging in for #{user_type}"
    creds = PortalTestHelper.get_user_credentials(user_type)
    puts "creds = #{creds.inspect}"

    # Fill in form with creds (email/password)
    SeleniumHelper.try_to { UserSessionTestHelper.login_test(creds[:email], creds[:password], driver) }
    puts "Waiting for element on footer GLOBO © 2018" #Waiting for element on footer GLOBO © 2018
    SeleniumHelper.wait_for_element(driver, 'GLOBO © 2018')
    sleep 1
    #checking if Footer is already displayed and user agreement is displayed
    ### TO DO add a way to end user session(data method --> delete) so that when user bumps to user agreement page, system will end or delete the session.
    if driver.find_elements(:id => 'theme-footer').size > 0 || driver.find_elements(:id, 'new_user_agreement_version').size > 0
        puts "User logs out" #waiting for Log out button to show
        PortalTestHelper.logout(url,driver,user_type) 
        puts "Success logging in for #{user_type}"
        return {passed: true, name: "Simple Login for #{user_type}"}
    else
        puts "Error on logging in for #{user_type}" 
        return {passed: false, name: "Simple Login for #{user_type}"}
    end
  end


  def self.two_factor_login
    return {passed: true, name: 'Two-Factor Login'}
  end


  def self.invalid_login_test1(driver, url="https://portal.dev.helloglobo.com", user_type)
    #Test for invalid password
    driver = driver || SeleniumHelper.get_driver #uses the passed in driver or gets it from selenium
    driver.navigate.to(url) #defaults to staging, make sure to add the rest of the sign in url
    puts "Start of invalid log in test for #{user_type}"
    creds = PortalTestHelper.get_user_credentials(user_type)
    puts "creds = #{creds.inspect}"

    puts "Test 1--> input valid email and invalid password"
    SeleniumHelper.try_to { UserSessionTestHelper.login_test(creds[:email], "password", driver) } # fill in form with creds (valid email/ invalid password)
    puts "show Invalid Password error message" #wait until the error message shows for Invalid Password
    SeleniumHelper.wait_for_element(driver, 'Invalid Password')
    driver.find_element(:id, "user_email").clear
    driver.find_element(:id, "user_password").clear
    sleep 2
    if driver.find_elements(:xpath, '//*[@id="error_explanation"]/h3').size > 0
        puts "Success on invalid log in for #{user_type}"  
        return {passed: true, name: "Test 1: Invalid Login(Invalid Password) for #{user_type}"}
    else
        puts "Error on invalid log in for #{user_type}" 
        return {passed: false, name: "Test 1: Invalid Login(Invalid Password) for #{user_type}"}
    end
  end


  def self.invalid_login_test2(driver, url="https://portal.dev.helloglobo.com", user_type)
    #Test for invalid email
    driver = driver || SeleniumHelper.get_driver #uses the passed in driver or gets it from selenium
    driver.navigate.to(url) #defaults to staging, make sure to add the rest of the sign in url
    puts "Start of invalid log in test for #{user_type}"
    creds = PortalTestHelper.get_user_credentials(user_type)
    puts "creds = #{creds.inspect}"

    puts "Test 2--> input invalid email and valid password"
    SeleniumHelper.try_to { UserSessionTestHelper.login_test("invalidemailtest@globo.email", creds[:password], driver) } # fill in form with creds (invalid email/ valid password)
    puts "show Invalid Email error message" #wait until the error message shows for Invalid Email
    SeleniumHelper.wait_for_element(driver, 'Invalid Email or password.')
    driver.find_element(:id, "user_email").clear
    driver.find_element(:id, "user_password").clear
    sleep 2
    if driver.find_elements(:xpath, '//*[@id="error_explanation"]/h3').size > 0
        puts "Success on invalid log in for #{user_type}"  
        return {passed: true, name: "Test 2: Invalid Login(Invalid Email) for #{user_type}"}
    else
        puts "Error on invalid log in for #{user_type}" 
        return {passed: false, name: "Test 2: Invalid Login(Invalid Email) for #{user_type}"}
    end
  end


  def self.invalid_login_test3(driver, url="https://portal.dev.helloglobo.com", user_type)
    #Test for invalid email and password
    driver = driver || SeleniumHelper.get_driver #uses the passed in driver or gets it from selenium
    driver.navigate.to(url) #defaults to staging, make sure to add the rest of the sign in url
    puts "Start of invalid log in test for #{user_type}"
    creds = PortalTestHelper.get_user_credentials(user_type)
    puts "creds = #{creds.inspect}"

    puts "Test 3--> input invalid email and valid password"
    SeleniumHelper.try_to { UserSessionTestHelper.login_test("invalidemailtest@globo.email", "password", driver) } # fill in form with creds (invalid email/ invalid password)
    puts "show Invalid Email and Password error message" #wait until the error message shows for Invalid Email and Password
    SeleniumHelper.wait_for_element(driver, 'Invalid Email or password.')
    driver.find_element(:id, "user_email").clear
    driver.find_element(:id, "user_password").clear
    sleep 2
    if driver.find_elements(:xpath, '//*[@id="error_explanation"]/h3').size > 0
        puts "Success on invalid log in for #{user_type}"  
        return {passed: true, name: "Test 3: Invalid Login(Invalid Email and Password) for #{user_type}"}
    else
        puts "Error on invalid log in for #{user_type}" 
        return {passed: false, name: "Test 3: Invalid Login(Invalid Email and Password) for #{user_type}"}
    end
  end


  def self.test_navigate_url
    # MUST change credentials for your special user, this way you can tests specific things that apply to just your user (since we are sharing credentials for the commoon login cases)
    PortalTestHelper.navigate('https://globoqa.com/dashboard/index', SeleniumHelper.get_driver, 'special_user')
  end


  def self.change_first_name(driver, env, user_type)
    #Test for changing user's first name
    puts "#{env}, #{user_type}"
    driver = driver || SeleniumHelper.get_driver #uses the passed in driver or gets it from selenium
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it")
    sleep 1
    original_value = driver.find_element(:id => 'profile_first_name')['value'] # store the original value in a variable
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
    sleep 1
    driver.find_element(:id, 'profile_first_name').clear
    test_value = 'Updated first name' #enter new values and save it on new_value variable
    driver.find_element(:id, 'profile_first_name').send_keys(test_value)
    driver.find_element(:name, 'commit').click
    sleep 1
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it")
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
    sleep 1
    updated_value = driver.find_element(:id => 'profile_first_name')['value'] # check if updated changes is saved 
    puts updated_value == test_value
    if updated_value == test_value
      puts "value matched!"
      driver.find_element(:xpath, '//*[@id="profile_first_name"]').text.include?('Updated first name')
      puts "restore the original value"
      driver.find_element(:id, 'profile_first_name').clear
      driver.find_element(:id, 'profile_first_name').send_keys(original_value)
      driver.find_element(:name, 'commit').click
      puts "submitted!"
      sleep 1
      SeleniumHelper.wait_for_element(driver,'Profile was successfully updated.')
      PortalTestHelper.logout("#{env}",driver,user_type)      #click on log out
      return {passed: true, name: "Changed First Name of #{user_type}"}
    else 
      puts "Value did not matched! Entered value did not save!"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: 'Changed First Name of #{user_type}'} if !SeleniumHelper.wait_for_element(driver,'Profile was successfully updated.')
    end
  end


  def self.change_last_name(driver, env, user_type)
    #Test for changing user's last name
    puts "#{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 1
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it") #added wait_for_element on seleniumhelper
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
    sleep 1
    original_value = driver.find_element(:id => 'profile_last_name')['value'] # store the original value in a variable
    puts "original value =  #{original_value}"
    sleep 1
    driver.find_element(:id, 'profile_last_name').clear
    test_value = 'Updated last name' #enter new values and save it on new_value variable
    driver.find_element(:id, 'profile_last_name').send_keys(test_value)
    driver.find_element(:name, 'commit').click
    sleep 1
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it")
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
    sleep 1
    updated_value = driver.find_element(:id => 'profile_last_name')['value'] # check if updated changes is saved 
    puts updated_value == test_value
    if updated_value == test_value
      puts "value matched!"
      driver.find_element(:id, 'profile_last_name')
      driver.find_element(:xpath, '//*[@id="profile_last_name"]').text.include?('Updated last name')
      puts "restore the original value"
      driver.find_element(:id, 'profile_last_name').clear
      driver.find_element(:id, 'profile_last_name').send_keys(original_value)
      driver.find_element(:name, 'commit').click
      puts "submitted!"
      SeleniumHelper.wait_for_element(driver,'Profile was successfully updated.')
      sleep 1
      PortalTestHelper.logout("#{env}",driver,user_type) # click on log out
      return {passed: true, name: "Changed Last Name of #{user_type}"}
    else 
      puts "Value did not matched! Entered value did not save!"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Changed Last Name of #{user_type}"} unless SeleniumHelper.wait_for_element(driver,'Profile was successfully updated.')
    end
  end


  def self.change_gender(driver, env, user_type)
    #Test for change user's gender
    puts "#{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 1
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it") #added wait_for_element on seleniumhelper
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
    SeleniumHelper.wait_for_element(driver, "Update")
    sleep 1
    driver.find_element(:xpath, '//*[@id="select2-profile_gender-container"]').click
    element = driver.find_element(:xpath, '/html/body/span/span/span[1]/input')
    element.send_keys "Please Select"
    element.send_keys:return
    driver.find_element(:name, 'commit').click
    sleep 1
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it")
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click #change back to original value
    sleep 1
    SeleniumHelper.wait_for_element(driver, "Update")
    driver.find_element(:class, 'select2-selection__rendered').text.include?('Please Select') #checks if gender was added successfully
    driver.find_element(:xpath, '//*[@id="select2-profile_gender-container"]').click
    element = driver.find_element(:xpath, '/html/body/span/span/span[1]/input')
    element.send_keys "Female"
    element.send_keys:return
    driver.find_element(:name, 'commit').click
    puts "submitted!"
    sleep 1
    SeleniumHelper.wait_for_element(driver,'Profile was successfully updated.')
    PortalTestHelper.logout("#{env}",driver,user_type) #clicks on log out
    return {passed: true, name: "Changed Gender of #{user_type}"}
  end


  def self.change_timezone(driver, env, user_type)
    #Test for changing user's timezone
    puts "#{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 1
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it") #added wait_for_element on seleniumhelper
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
    SeleniumHelper.wait_for_element(driver, "Update")
    sleep 1
    driver.find_element(:xpath, '//*[@id="select2-profile_user_time_zone-container"]').click
    element = driver.find_element(:xpath, '/html/body/span/span/span[1]/input')
    element.send_keys "Please Select"
    element.send_keys:return
    driver.find_element(:name, 'commit').click
    sleep 1
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it")
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click #change back to original value
    sleep 1
    SeleniumHelper.wait_for_element(driver, "Update")
    driver.find_element(:class, 'select2-selection__rendered').text.include?('Please Select') #checks if gender was added successfully
    driver.find_element(:xpath, '//*[@id="select2-profile_user_time_zone-container"]').click
    element = driver.find_element(:xpath, '/html/body/span/span/span[1]/input')
    element.send_keys "America - New York"
    element.send_keys:return
    driver.find_element(:name, 'commit').click
    puts "submitted!"
    sleep 1
    SeleniumHelper.wait_for_element(driver,'Profile was successfully updated.')
    PortalTestHelper.logout("#{env}",driver,user_type) #click on log out
    return {passed: true, name: "Changed Timezone of #{user_type}"}
  end


  def self.adding_department_to_user(driver, env, user_type)
    #Test for adding department to a user
    puts "#{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 2
    department_list = PortalTestHelper.get_user_departments(user_type)

    #For SysAdmin: Test if user has the ability to view and update the department field
    if department_list[:can_read]==true and department_list[:can_update]==true      
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      sleep 1
      SeleniumHelper.wait_for_element(driver, "Update")
      driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").click
      element = driver.find_element(:xpath, "//input[@type='search']")
      element.send_keys "Test Department2"
      # Checks if there's an existing Test Department2 in the department list otherwise returns a result that the department is not found
      department_exists = driver.find_element(:class, 'select2-results__option').text.include?('Test Department2')
      if department_exists == false
        element.send_keys:return
        driver.find_element(:name, 'commit').click
        SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it")
        driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
        SeleniumHelper.wait_for_element(driver, "Update")
        sleep 1
        # Checks if Test Department2 was added successfully
        driver.find_element(:class, 'select2-selection__choice').text.include?('Test Department2')
        driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").click
        element = driver.find_element(:css, 'form.form-horizontal input[class="select2-search__field"]')
        element.send_keys:backspace
        driver.find_element(:name, 'commit').click
        SeleniumHelper.wait_for_element(driver,'Profile was successfully updated.')
        PortalTestHelper.logout("#{env}",driver,user_type) #click on log out
        return {passed: true, name: "Adding Department to #{user_type}: Successfully added department to user "}
      else
        puts "Error on adding department to user #{user_type}"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Adding Department to #{user_type}: Unable to add department. Test Department2 is not found!"}
      end
    end
      
    #For Internal Employee: Test if user has the ability to view and update the department field
    if department_list[:can_read]==true and department_list[:can_update]==false
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      sleep 1
      SeleniumHelper.wait_for_element(driver, "Update")
      # Check to see if Department field displays but disabled for Internal Employee user. If it is disabled then this test PASS, if not, returns an error message
      dept_aria_expanded = driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").attribute("aria-expanded")
      department = driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").text
      if dept_aria_expanded == "false" and department == "Test Department1"
        puts "aria-expanded is false this means the department is disabled for user, therefore this should pass the test for user with can_update = false"
        sleep 1
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Adding Department to #{user_type}: Department field is displayed and disabled"}
      else
        puts "department is enabled then it should fail this test"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Adding Department to #{user_type}: Department field is displayed but not assigned to any department"}
      end
    end

    #For other users: Test if user without the permission to read/update will not be able to see the department field
    if department_list[:can_read]==false and department_list[:can_update]==false
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      SeleniumHelper.wait_for_element(driver, "Update")
      sleep 1
      departmentVisible = driver.find_element(:class, 'form-group').text.include?('Department(s)')
      if departmentVisible == false
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Adding Department to #{user_type}: Department field is not shown"}
      else
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Adding Department to #{user_type}: Department field is being shown"}
      end
    end
  end


  def self.remove_department(driver, env, user_type)
    #Test for removing a department to a user
    #user with departments must start with ONLY "Test Department 1", otherwise this will fail (expecting user to only have 1 department to start with)
    puts "#{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 2
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it")
    department_list = PortalTestHelper.get_user_departments(user_type)

    #For SysAdmin: Test if user has the ability to view and update the department field
    if department_list[:can_read]==true and department_list[:can_update]==true
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      sleep 1
      SeleniumHelper.wait_for_element(driver, "Update")
      # Checks if Test Department1 exists first otherwise it will end the test right away and return a result.
      department = driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").text
      if department == "×Test Department1"
        driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").click
        element = driver.find_element(:css, 'form.form-horizontal input[class="select2-search__field"]')
        element.send_keys:backspace
        driver.find_element(:name, 'commit').click
        SeleniumHelper.wait_for_element(driver,'Profile was successfully updated.')
        PortalTestHelper.logout("#{env}",driver,user_type) #click on log out
        return {passed: true, name: "Removing Department from #{user_type}: Successfully remove department"}
      else
        driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").click
        element = driver.find_element(:xpath, "//input[@type='search']")
        element.send_keys "Test Department1"
        element.send_keys:return
        driver.find_element(:name, 'commit').click
        SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it")
        PortalTestHelper.logout("#{env}",driver,user_type) #click on log out
        return {passed: true, name: "Removing Department from #{user_type}: Successfully remove department"}
      end
    end

    #For Internal Employee: Test if user has the ability to view and update the department field
    if department_list[:can_read]==true and department_list[:can_update]==false
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      sleep 1
      SeleniumHelper.wait_for_element(driver, "Update")
      # Check to see if Department field displays but disabled for Internal Employee user. If it is disabled then this test PASS, if not, returns an error message
      driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").click
      dept_aria_expanded = driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").attribute("aria-expanded")
      department = driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").text
      puts "Checks if the field is disabled and if it is assigned to Test Department 1"
      if dept_aria_expanded == "false" and department == "Test Department1"
        puts "aria-expanded is false this means the department is disabled for user, therefore this should pass the test for user with can_update = false"
        sleep 1
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Removing Department from #{user_type}: Department field is displayed and disabled"}
      else
        puts "department is enabled and not assigned to Test Department1 then it should fail this test"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Removing Department from #{user_type}: Department field is either enabled or Test Department1 is not assigned"}
      end
    end

    #For other users: Test if user without the permission to read/update will not be able to see the department field
    if department_list[:can_read]==false and department_list[:can_update]==false
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      SeleniumHelper.wait_for_element(driver, "Update")
      sleep 1
      departmentVisible = driver.find_element(:class, 'form-group').text.include?('Department(s)')
      puts "Is Department field displayed? = #{departmentVisible}"
      if departmentVisible == false
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Removing Department from #{user_type}: Department field is not shown"}
      else
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Removing Department from #{user_type}: Department field is being shown"}
       end
    end
  end


  def self.department_existence(driver, env, user_type)
    #Test for checking department existence to a user
    puts "#{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 2
    SeleniumHelper.wait_for_element(driver, "leave blank if you don't want to change it")
    department_list = PortalTestHelper.get_user_departments(user_type)

    #For SysAdmin: Test if user has the ability to view and update the department field
    if department_list[:can_read]==true and department_list[:can_update]==true
      puts department_list
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      sleep 1
      SeleniumHelper.wait_for_element(driver, "Update")
      department = driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").displayed?
      puts "Is Department field displayed for #{user_type}?  #{department}"
      if department == true
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Test department existence for #{user_type}: Department field is shown/existing"}
      else
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Test department existence for #{user_type}: Department field is not shown/existing"}
      end
    end
    
    #For Internal Employee: Test if user has the ability to view and update the department field
    if department_list[:can_read]==true and department_list[:can_update]==false
      puts department_list
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      sleep 1
      SeleniumHelper.wait_for_element(driver, "Update")
      department = driver.find_element(:xpath, "//span[@class='select2-selection select2-selection--multiple']").displayed?
      puts "Is Department field displayed for #{user_type}?  #{department}"
      if department == true
        PortalTestHelper.logout("#{env}",driver,user_type) #department exists for this user
        return {passed: true, name: "Test department existence for #{user_type}: Department field is shown/existing"}
      else
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Test department existence for #{user_type}: Department field is not shown/existing"}
      end
    end

    #For other users: Test if user without the permission to read/update will not be able to see the department field
    if department_list[:can_read]==false and department_list[:can_update]==false
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      SeleniumHelper.wait_for_element(driver, "Update")
      sleep 1
      departmentVisible = driver.find_element(:class, 'form-group').text.include?('Department(s)')
      puts "Is Department field displayed? = #{departmentVisible}"
      if departmentVisible == false
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Test department existence for #{user_type}: Department field is not shown/existing"}
      else
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Test department existence for #{user_type}: Department field is shown/existing"}
       end
    end
  end


  def self.new_password_doesnt_meet_conditions(driver, env, user_type)
    #GAUIT-26 Failing to Reset Password
    #First test for Failed Password Reset
    #New password doesn't meet necessary conditions
    puts "Reset Password test for #{user_type}: New password doesn't meet necessary conditions"
    puts "Checking if the user type is two_factor_enabled or two_factor_and_password_policy"
    if user_type == 'two_factor_enabled' || user_type == 'two_factor_and_password_policy'
      puts "We are not testing for these user types so user logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "We are not testing 2 factor at the moment"}
    end

    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 1
    SeleniumHelper.wait_for_element(driver, "My Profile")
    puts "Getting current password of the users on the list"
    user_password = PortalTestHelper.get_user_credentials(user_type) #retrieving user's current password
    puts "User goes to Account Information tab"
    SeleniumHelper.wait_for_element(driver, "Account Information")

    puts "Password Policy Enabled User test"
    if user_type == 'password_policy_enabled'
      puts "Password Policy Enabled user test"
      driver.find_element(:name, 'user[password]').send_keys("passwor") #puts "Input New Password"
      driver.find_element(:name, 'user[password_confirmation]').send_keys("passwor") #puts "Confirm New Password" 
      driver.find_element(:name, 'user[current_password]').send_keys(user_password[:password]) #puts "Input Current Password"
      puts "Click Update button" #Clicking Update button to attempt to save the password change.
      driver.find_element(:name, 'update_user_registration').click
      update_button = driver.find_element(:xpath, "//*[@id='update-password']").enabled?
      puts "Is update button enabled? #{update_button}"
      puts "checks for expected error messages"
      element1 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[1]").attribute("class").include?("ko length null")
      puts "condition1:  #{element1}"
      element2 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[2]").attribute("class").include?("lowercase ok null")
      puts "condition2:  #{element2}"
      element3 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[3]").attribute("class").include?("ko uppercase null")
      puts "condition3:  #{element3}"
      element4 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[4]").attribute("class").include?("ko number null")
      puts "condition4:  #{element4}"
      element5 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[5]").attribute("class").include?("ko special-char null")
      puts "condition5:  #{element5}"
      element6 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[6]").attribute("class").include?("match ok null")
      puts "condition6:  #{element6}"
      if element1 && element2 && element3 && element4 && element5 && element6 == true
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Test password reset conditions for logged in #{user_type}: New password doesn't meet necessary conditions"}
      else
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Test password reset conditions for logged in #{user_type}: Either one of the expected conditions failed or update button is enabled and saved changes made"}
      end
    end

    puts "No Password Policy User test"
    driver.find_element(:name, 'user[password]').send_keys("passwor")
    driver.find_element(:name, 'user[password_confirmation]').send_keys("passwor")
    driver.find_element(:name, 'user[current_password]').send_keys(user_password[:password])
    puts "Click Update button"
    driver.find_element(:name, 'update_user_registration').click
    update_button = driver.find_element(:xpath, "//*[@id='update-password']").enabled?
    puts "Is update button enabled? #{update_button}"
    element1 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[1]").attribute("class").include?("ko length null")
    puts "condition1:  #{element1}"
    element2 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[2]").attribute("class").include?("match ok null")
    puts "condition2:  #{element2}"
    if element1 && element2 == true
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Test password reset conditions for logged in #{user_type}: New password doesn't meet necessary conditions"}
    else
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Test password reset conditions for logged in #{user_type}: New password was saved!"}
    end
  end


  def self.incorrect_password_confirmation(driver, env, user_type)
    #Second test for Failed Password Reset
    #Password Confirmation doesn't match the new password
    puts "Reset Password test for #{user_type}: Password Confirmation doesn't match the new password"
    if user_type == 'two_factor_enabled' || user_type == 'two_factor_and_password_policy'
      puts "We are not testing for these user types so user logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "We are not testing 2 factor at the moment"}
    end

    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 1
    SeleniumHelper.wait_for_element(driver, "My Profile")
    puts "Getting current password of the users on the list"
    user_password = PortalTestHelper.get_user_credentials(user_type) #retrieving user's current password
    puts "User goes to Account Information tab"
    SeleniumHelper.wait_for_element(driver, "Account Information")

    puts "Password Policy Enabled User test"
    if user_type == 'password_policy_enabled'
      puts "Password Policy Enabled user test, input P@$$w0rd on new password and P@$$w00rd on confirm password"
      SeleniumHelper.try_to { UserSessionTestHelper.change_password("P@$$w0rd", "P@$$w00rd", user_password[:password], driver) }
      puts "Click Update button" #Clicking Update button to attempt to save the password change.
      driver.find_element(:name, 'update_user_registration').click
      update_button = driver.find_element(:xpath, "//*[@id='update-password']").enabled?
      puts "Is update button enabled? #{update_button}"
      puts "checks for expected error messages"
      element1 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[1]").attribute("class").include?("length ok null")
      puts "condition1:  #{element1}"
      element2 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[2]").attribute("class").include?("lowercase ok null")
      puts "condition2:  #{element2}"
      element3 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[3]").attribute("class").include?("uppercase ok null")
      puts "condition3:  #{element3}"
      element4 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[4]").attribute("class").include?("number ok null")
      puts "condition4:  #{element4}"
      element5 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[5]").attribute("class").include?("special-char ok null")
      puts "condition5:  #{element5}"
      element6 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[6]").attribute("class").include?("ko match null")
      puts "condition6:  #{element6}"
      if element1 && element2 && element3 && element4 && element5 && element6 == true
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Test password reset conditions for logged in #{user_type}: Password Confirmation doesn't match the new password"}
      else
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Test password reset conditions for logged in #{user_type}: Either one of the expected conditions failed or update button is enabled and saved changes made"}
      end
    end

    puts "No Password Policy User test, input 'password', 'passwor' "
    SeleniumHelper.try_to { UserSessionTestHelper.change_password("password", "passwor", user_password[:password], driver) }
    puts "Click Update button"
    driver.find_element(:name, 'update_user_registration').click
    update_button = driver.find_element(:xpath, "//*[@id='update-password']").enabled?
    puts "Is update button enabled? #{update_button}"
    element1 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[1]").attribute("class").include?("length ok null")
    puts "condition1:  #{element1}"
    element2 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[2]").attribute("class").include?("ko match null")
    puts "condition2:  #{element2}"
    if element1 && element2 == true
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Test password reset conditions for logged in #{user_type}: Password Confirmation doesn't match the new password"}
    else
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Password Confirmation doesn't match the new password test for #{user_type}: Either one of the expected conditions failed or update button is enabled and saved changes made"}
    end 
  end


  def self.incorrect_current_password(driver, env, user_type)
    #Third test for Failed Password Reset
    #Current password is not correct
    puts "Reset Password test for #{user_type}: Password Confirmation doesn't match the new password"
    if user_type == 'two_factor_enabled' || user_type == 'two_factor_and_password_policy'
      puts "We are not testing for these user types so user logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "We are not testing 2 factor at the moment"}
    end

    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 1
    SeleniumHelper.wait_for_element(driver, "My Profile")
    puts "Getting current password of the users on the list"
    user_password = PortalTestHelper.get_user_credentials(user_type)     #retrieving user's current password
    puts "User goes to Account Information tab"
    SeleniumHelper.wait_for_element(driver, "Account Information")

    puts "Password Policy Enabled User test"
    if user_type == 'password_policy_enabled'
      puts "Password Policy Enabled user test, input 'P@$$w0rd1', 'P@$$w0rd1', 'Temp123' "
      SeleniumHelper.try_to { UserSessionTestHelper.change_password("P@$$w0rd", "P@$$w0rd", "Temp123", driver) }
      driver.find_element(:name, 'update_user_registration').click
      update_button = driver.find_element(:xpath, "//*[@id='update-password']").enabled?
      puts "Is update button enabled? #{update_button}"
      puts "checks for expected error messages"
      element1 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[1]").attribute("class").include?("length ok null")
      puts "condition1:  #{element1}"
      element2 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[2]").attribute("class").include?("lowercase ok null")
      puts "condition2:  #{element2}"
      element3 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[3]").attribute("class").include?("uppercase ok null")
      puts "condition3:  #{element3}"
      element4 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[4]").attribute("class").include?("number ok null")
      puts "condition4:  #{element4}"
      element5 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[5]").attribute("class").include?("special-char ok null")
      puts "condition5:  #{element5}"
      element6 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[6]").attribute("class").include?("match ok null")
      puts "condition6:  #{element6}"
      if element1 && element2 && element3 && element4 && element5 && element6 == true
        update_button = driver.find_element(:xpath, "//*[@id='update-password']").enabled?
        puts "Is update button enabled? #{update_button}"
        driver.find_element(:name, 'update_user_registration').click
        sleep 1
      end
      error_message = driver.find_element(:xpath, '//*[@id="error_explanation"]/ul/li').text.include?('Current password is invalid')
      if error_message == true
        puts "Error message is displayed"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "Test password reset conditions for logged in #{user_type}: Current password is not correct"}
      else
        puts "Error message is not displayed"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "Test password reset conditions for logged in #{user_type}: Incorrect current password was accepted!"}
      end
    end

    puts "No Password Policy User test, input 'password', 'password', 'Temp123' "
    SeleniumHelper.try_to { UserSessionTestHelper.change_password("password", "password", "Temp123", driver) }
    element1 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[1]").attribute("class").include?("length ok null")
    puts "condition1:  #{element1}"
    element2 = driver.find_element(:xpath, "//*[@id='passwordComplexity']/ul/li[2]").attribute("class").include?("match ok null")
    puts "condition2:  #{element2}"
    if element1 && element2 == true
      update_button = driver.find_element(:xpath, "//*[@id='update-password']").enabled?
      puts "Is update button enabled? #{update_button}"
      driver.find_element(:name, 'update_user_registration').click
      sleep 1
    else
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Test password reset conditions for logged in #{user_type}: One of the expected conditions failed"}
    end
    error_message = driver.find_element(:xpath, '//*[@id="error_explanation"]/ul/li').text.include?('Current password is invalid')
    if error_message == true
      puts "Error message is displayed"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Test password reset conditions for logged in #{user_type}: Current password is not correct"}
    else
      puts "Error message is not displayed"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Test password reset conditions for logged in #{user_type}: Incorrect current password was accepted!"}
    end  
  end


  def self.enter_previous_password(driver, env, user_type)
    #Fourth test for Failed Password Reset
    #Cannot enter previous or current password
    puts "Reset Password test for #{user_type}: Password Confirmation doesn't match the new password"
    if user_type == 'two_factor_enabled' || user_type == 'two_factor_and_password_policy'
      puts "We are not testing for these user types so user logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)      
      return {passed: true, name: "We are not testing 2 factor at the moment"}
    end
    
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    sleep 1
    SeleniumHelper.wait_for_element(driver, "My Profile")
    user_password = PortalTestHelper.get_user_credentials(user_type) #puts "Getting current password of the users on the list"
    SeleniumHelper.try_to { UserSessionTestHelper.change_password(user_password[:password], user_password[:password], user_password[:password], driver) }
    driver.find_element(:name, 'update_user_registration').click
    sleep 1
    error_message = driver.find_element(:xpath, '//*[@id="error_explanation"]/ul/li').text.include?('Password must be different to the current password')
    puts "error message: #{error_message}" #Shows the error message "Password must be different to the current password"
    if error_message == true
      puts "error message is shown: Password must be different to the current password"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Test password reset conditions for logged in #{user_type}: Password cannot be the current password"}
    else
      puts "error message is now shown"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Test password reset conditions for logged in #{user_type}: Failed! Password was saved!"}
    end
  end


  def self.change_address_test(driver, env, user_type)
    #Test for changing address to a user
    puts "Start of change_address_test for #{user_type}"
    puts "TEST DETAILS : #{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    SeleniumHelper.wait_for_element(driver, "My Profile")
    puts "Checking if user_role has permission to read and update addresses"
    user_address = PortalTestHelper.get_user_addresses(user_type)
    if user_address[:can_read]==false and user_address[:can_update]==false
      puts "#{user_type} has no permission on the Profile addresses. #{user_type} address is empty"
      puts "End of test. Click on log out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      puts "No Address traced for #{user_type}"
      return {passed: true, name: "No Address is associated for #{user_type}.#{user_type} has no permission to view or modify addresses"}
    end

    puts "User expands Profile tab"
    sleep 1
    SeleniumHelper.wait_for_element(driver, "Profile")
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
    sleep 1
    puts "User clicks Home Address dropdown option"
    driver.find_element(:xpath, '//*[@id="select2-profile_home_address_id-container"]').click
    puts "No Results found on the Address dropdown" # Test when no address is found for the user role
    no_results = driver.find_element(:xpath, '//*[@id="select2-profile_home_address_id-results"]/li').text.include?('No results found')
    if no_results == true
      puts "End of test. Click on log out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      puts "No Address found for #{user_type}"
      return {passed: false, name: "No Address found for #{user_type}"}
    end
    puts "#{user_type} address is not empty" #Test when address for user is not empty and has permissions
    address = driver.find_element(:xpath, '/html/body/span/span/span[1]/input')
    address.send_keys("Address 2")
    address.send_keys:return
    sleep 1
    puts "User clicks Update button to save changes"
    driver.find_element(:name, 'commit').click
    puts "Success changing address to Address 2" #go to Profile tab again to check
    sleep 1
    SeleniumHelper.wait_for_element(driver, "Profile")
    sleep 1
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
    sleep 1
    puts "Checking if the address is changed to Address 2" #Checking if the address is changed to Address 2
    address_check = driver.find_element(:id, 'select2-profile_home_address_id-container').text.include?('Address 2')
    if address_check == true
      puts "Put back original value = Address 1"
      puts "User clicks Home Address dropdown option"
      driver.find_element(:xpath, '//*[@id="select2-profile_home_address_id-container"]').click
      puts "User changes from Address 2 to Address 1"
      address = driver.find_element(:xpath, '/html/body/span/span/span[1]/input')
      address.send_keys("Address 1")
      address.send_keys:return
      sleep 1
      puts "User clicks Update to save changes and bring back original value = Address 1"
      driver.find_element(:name, 'commit').click
      puts "Success putting back to Address 1"
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      puts "Change Address Successful for #{user_type}"
      return {passed: true, name: "Change Address Successful for #{user_type}"}
    else
      puts "Error on change address for #{user_type}"
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Error on change address #{user_type}"}
    end
  end


  def self.reset_password_test(driver, env, user_type)
    #Reset password tests (GAUIT-25 - changing password on User's profile)
    puts "Reset Password test for #{user_type}"
    puts "TEST DETAILS : #{env}, #{user_type}"
    puts "Checking if the user type is two_factor_enabled or two_factor_and_password_policy"
    if user_type == 'two_factor_enabled' || user_type == 'two_factor_and_password_policy'
      PortalTestHelper.logout("#{env}",driver,user_type)
      puts "We are not testing for these user types so user logs out"
      return {passed: true, name: "We are not testing 2 factor at the moment"}
    end

    # this is for no_password_policy users
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    SeleniumHelper.wait_for_element(driver, "My Profile")
    sleep 1
    puts "Getting current password of the users on the list"
    user_password = PortalTestHelper.get_user_credentials(user_type)
    SeleniumHelper.try_to { UserSessionTestHelper.change_password("NewPassword1234!", "NewPassword1234!", user_password[:password], driver) }
    driver.find_element(:name, 'update_user_registration').click
    sleep 1
    puts "Checking if the user has changed his password by going to the home page and no error message show"
    password_check = driver.find_element(:xpath, '//*[@id="header_target"]').text.include?('Home')
    if !password_check
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Failed for #{user_type} to change password."}
    end

    puts "Change password for user type is successful"
    puts "Putting back the default password Temp1234!"
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
    SeleniumHelper.wait_for_element(driver, "My Profile")
    sleep 1

    #check for password policy to see if that's the issue of resetting it back
    if user_type == 'password_policy_enabled'
      #need to change password 3 times
      puts "Checking is user_type = password_policy_enabled"
      puts "Changing password 3 times"

      puts "Changing the first time"
      PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
      SeleniumHelper.wait_for_element(driver, "My Profile")
      sleep 1
      SeleniumHelper.try_to { UserSessionTestHelper.change_password("FirstPasswordChange1234!", "FirstPasswordChange1234!", "NewPassword1234!", driver) }
      driver.find_element(:name, 'update_user_registration').click

      puts "changing the second time"
      PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
      SeleniumHelper.wait_for_element(driver, "My Profile")
      sleep 1
      SeleniumHelper.try_to { UserSessionTestHelper.change_password("SecondPasswordChange1234!", "SecondPasswordChange1234!", "FirstPasswordChange1234!", driver) }      
      driver.find_element(:name, 'update_user_registration').click

      puts "changing the third time, setting the original password"
      PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
      SeleniumHelper.wait_for_element(driver, "My Profile")
      sleep 1
      SeleniumHelper.try_to { UserSessionTestHelper.change_password(user_password[:password],user_password[:password], "SecondPasswordChange1234!", driver) }    
      driver.find_element(:name, 'update_user_registration').click
    else #you can then end the user_type check if statement here, again, this is to avoid nesting and easier readability
      SeleniumHelper.try_to { UserSessionTestHelper.change_password(user_password[:password], user_password[:password], "NewPassword1234!", driver) }
      driver.find_element(:name, 'update_user_registration').click
    end

    # now we check to see if resetting was successful once more
    homepage_check = driver.find_element(:xpath, '//*[@id="header_target"]').text.include?('Home')
    if homepage_check == true
      # resetting password to original password successful
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: true, name: "Reset Password Successful for #{user_type}."}
    else
      # resetting still unsuccessful, was not the password policy issue, so needs further investigation by manually testing
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Error on reset password #{user_type}. failed to reset back to the old password."}
    end
  end


  def self.add_address_test(driver, env, user_type)
    #Test add address for users
    puts "Start of add_address_test for #{user_type}"
    puts "TEST DETAILS : #{env}, #{user_type}"
    PortalTestHelper.navigate("#{env}users/edit",driver,user_type)

    #Checking if user has permission to make changes on user's address
    user_address = PortalTestHelper.get_user_addresses(user_type)
    puts "checking if #{user_type} has address permissions"
    if user_address[:can_read]==false and user_address[:can_update]==false
      puts "#{user_type} has no permission on the Profile addresses. #{user_type} address is empty"
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      puts "No Address traced for #{user_type}"
      return {passed: true, name: "#{user_type} has no permission for User's address section. No Address is associated for #{user_type}."}
    end

    #Test for user's with permission to make changes on the Address
    SeleniumHelper.wait_for_element(driver, "My Profile")
    puts "User expands Profile tab"
    SeleniumHelper.wait_for_element(driver, "Profile")
    sleep 1
    driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
    sleep 1
    puts "User clicks Here link on Home Address section(loads addressed page)"
    driver.find_element(:link, 'here').click
    sleep 1
    puts "User clicks New Address button"
    SeleniumHelper.wait_for_element(driver, "Addresses")
    driver.find_element(:link, 'New Address').click
    SeleniumHelper.wait_for_element(driver, "Address Information")
    puts "Inputting of address details"
    driver.find_element(:id, 'address_name').send_keys("Custom Address")
    driver.find_element(:id, 'address_street').send_keys("1200 Market St,")
    driver.find_element(:id, 'address_street2').send_keys("24 Avenue,")
    driver.find_element(:id, 'address_city').send_keys("Philadelphia")
    driver.find_element(:id, 'address_state').send_keys("Philadelphia")
    driver.find_element(:id, 'address_zip').send_keys("19107")
    puts "Saves new address"
    driver.find_element(:name, 'commit').click
    sleep 1

    #Check if Custom Address is added on the address list and changing default address to Custom Address
    puts "Check for the new address - Custom Address is added"
    new_address_added = driver.find_element(:class, "ibox-content").text.include?('Custom Address')
    if new_address_added == true
      puts "User sets the custom(new) address as the default address"
      puts "User go back to users My Profile page"
      PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
      puts "User expands Profile tab"
      SeleniumHelper.wait_for_element(driver, "Profile")
      sleep 1
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      sleep 1
      puts "User clicks Home Address dropdown option"
      driver.find_element(:xpath, '//*[@id="select2-profile_home_address_id-container"]').click
      puts "Changing #{user_type} address to the newly added address"
      address = driver.find_element(:xpath, '/html/body/span/span/span[1]/input')
      address.send_keys("Custom Address")
      puts "Custom Address found. Continue test for changing address to Custom Address"
      address.send_keys:return
      sleep 1
      puts "User clicks Update button to save changes"
      driver.find_element(:name, 'commit').click
      puts "Success changing default address from Address 1 to Custom Address"
      SeleniumHelper.wait_for_element(driver, "Profile")
      sleep 1
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      sleep 1
    else
      puts "New address - Custom Address is not added. User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "Failed to add a new address for #{user_type}"}
    end    

    #Checking if the address is changed to Custom Address and deleting the custom address
    puts "Checking if the address is changed to Custom Address"
    address_check = driver.find_element(:id, 'select2-profile_home_address_id-container').text.include?('Custom Address')
    if address_check == true
      puts "Custom Address is the currect user's address. Deleting Custom Address"
      puts "User clicks Here link on Home Address section(loads addressed page)"
      driver.find_element(:link, 'here').click      #find the table rows on the page
      table = driver.find_elements(:xpath, '//*[contains(@class, "table")]/tbody/tr')
      table.shift # shift out the header row so you don't worry about it
      row_number = -1 # setting the row_number to -1 in case the address you are looking for cannot be found
      table.each_with_index do |row, index|
        puts "row #{index} includes address = #{row.text.include?("Custom Address")}"
        next unless row.text.include?("Custom Address") #skip unless you find the right row with the address named "Custom Address"
        row_number = index + 1 # add 1 to the index since we shifted out the header row
      end

      # if row_number is still -1, then that means the row was not found with the address expected.
      correct_row = row_number >= 0 ? driver.find_element(:xpath, "//*[contains(@class, 'table')]/tbody/tr[#{row_number+1}]").text.include?("Custom Address") : false
      if correct_row
        delete_button = driver.find_element(:xpath, "//*[contains(@class, 'table')]/tbody/tr[#{row_number+1}]/td[2]/a[2]")
        delete_button.click # clicks the delete button
        driver.switch_to().alert().accept(); #Click OK on the confirmation prompt
      end
      puts "Custom Address is deleted and default address should go back to Address 1"
      puts "Checking if Address 1 is the default address after deletion"
      PortalTestHelper.navigate("#{env}users/edit",driver,user_type)
      SeleniumHelper.wait_for_element(driver, "My Profile")
      puts "User expands Profile tab"
      SeleniumHelper.wait_for_element(driver, "Profile")
      sleep 1
      driver.find_element(:xpath, '//*[@id="collapse-group"]/div[2]/div[1]/div/a/h5').click
      sleep 1
    end

    #Test for checking and putting Address 1 as the default address
    puts "Checking Home Address dropdown if the default address is Address 1"
    address1_check = driver.find_element(:id, 'select2-profile_home_address_id-container').text.include?('Address 1')
    if address1_check == true
      puts "Default address is now Address 1, user logs out"
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      puts "Success deleting address Custom Address and putting default address to Address 1"
      return {passed: true, name: "Add Address Successful for #{user_type} and returning to default address -- Address 1"}
    else
      puts "Put back default address to Address 1"
      driver.find_element(:xpath, '//*[@id="select2-profile_home_address_id-container"]').click
      puts "Changing #{user_type} address to the first address(Address 1)"
      address = driver.find_element(:xpath, '/html/body/span/span/span[1]/input')
      address.send_keys("Address 1")
      address.send_keys:return
      sleep 1
      puts "User clicks Update button to save changes"
      driver.find_element(:name, 'commit').click
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      puts "Address 1 is not the default address so put back Address 1 as the default address"
      return {passed: false, name: "After deleting Custom Address, Address 1 is not the default address so manually put it back for #{user_type}"}
    end
  end

  def self.test_page_permissions(driver, env, user_type, page)
    PortalTestHelper.navigate("#{env}",driver,user_type)
    # => key: TIDashboard, name: 'Telephone Interpreting'
    #puts "this is a page #{page}" # => key: TIDashboard, name: 'Telephone Interpreting'.
    permissions = PortalTestHelper.get_user_permissions(user_type)
    # check to see if user has NO permission, pages should not be shown on the side navigation
    begin
      if (permissions[:pages][page[:key].to_sym] == '') && pageShown = driver.find_elements(:link => page[:name]).size > 0
        puts pageShown
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "User Permission - Side Navigation Test - #{page[:name]} page is shown even without permission for #{user_type}"}
      end
      if (permissions[:pages][page[:key].to_sym] == '') && !pageShown = driver.find_elements(:link => page[:name]).size > 0
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - No permission / #{page[:name]} page is not shown for #{user_type}"}
      end
    rescue StandardError => e
      puts "error in permission: #{e.message}"
      puts e.backtrace.inspect # This method returns an array of strings that represent the call stack at the point that the exception was raised.
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "User Permission - Side Navigation Test - #{page[:name]} page is not shown for #{user_type}"}
    end
    # check to see if user with permission can see the page and can navigate on it
    # check if there's subpages
    begin
      if (permissions[:pages][page[:key].to_sym] == 'R' || permissions[:pages][page[:key].to_sym] == 'RA' ||
          permissions[:pages][page[:key].to_sym] == 'RE' || permissions[:pages][page[:key].to_sym] == 'F' ||
          permissions[:pages][page[:key].to_sym] == 'FA' || permissions[:pages][page[:key].to_sym] == 'W' ||
          permissions[:pages][page[:key].to_sym] == 'WE') && page[:subname] == ""
        puts page
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to {driver.find_element(:link, page[:name]).text.include?(page[:name]) }
        SeleniumHelper.try_to {driver.find_element(:link, page[:name]).click }
        sleep 2
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - #{page[:name]} page for #{user_type}"}
      end
      if (permissions[:pages][page[:key].to_sym] == 'R' || permissions[:pages][page[:key].to_sym] == 'RA' ||
          permissions[:pages][page[:key].to_sym] == 'RE' || permissions[:pages][page[:key].to_sym] == 'F' ||
          permissions[:pages][page[:key].to_sym] == 'FA' || permissions[:pages][page[:key].to_sym] == 'W' ||
          permissions[:pages][page[:key].to_sym] == 'WE') && page[:subname] != ""
        #puts "print with subpage : #{subpage} "
        puts page
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to {driver.find_element(:link, page[:name]).text.include?(page[:name]) }
        SeleniumHelper.try_to {driver.find_element(:link, page[:name]).click }
        sleep 1
        #if there's subpages, it will click on the subpage
        SeleniumHelper.try_to {driver.find_element(:link, page[:subname]).click }
        sleep 2
        SeleniumHelper.wait_for_element(driver, page[:subname])
        puts 'subpage is displayed'
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - #{page[:subname]} page for #{user_type}"}
      end
      # For Agent Dashboard
      if (permissions[:pages][page[:key].to_sym]=='R-AgentDashboard')
        puts "Basic Test for TI Agent Dashboard"
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to { driver.find_element(:link,'Dashboard').text.include?('Dashboard') }
        puts 'Dashboard is displayed'
        SeleniumHelper.try_to { driver.find_element(:link,'Dashboard').click }
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Agent Dashboard')
        puts 'Agent Dashboard text is displayed'
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - TI Agent Dashboard for #{user_type}"}
      end
      # For Interpreter Dashboard
      if (permissions[:pages][:TIDashboard]=='R-TIDashboard')
        puts "Basic Test for TI Interpreter Dashboard"
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to { driver.find_element(:link,'Dashboard').text.include?('Dashboard') }
        puts 'Dashboard is displayed'
        SeleniumHelper.try_to { driver.find_element(:link,'Dashboard').click }
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Interpreter Dashboard')
        puts 'Interpreter Dashboard text is displayed'
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - TI Interpreter Dashboard for #{user_type}"}
      end
      # VRI Interpreter Dashboard
      if (permissions[:pages][:VideoInterpreting]=='R-VRIInterpreterDashboard')
        puts "Basic Test for VRI Interpreter Dashboard"
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to { driver.find_element(:xpath,'//*[@id="side-menu"]/li[2]/a/span').text.include?('Video Interpreting') }
        puts 'Video Interpreting is displayed'
        SeleniumHelper.try_to { driver.find_element(:xpath,'//*[@id="side-menu"]/li[2]/a/span').click }
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Video Interpreting')
        SeleniumHelper.wait_for_element(driver, 'Availability Status')
        puts 'Video Interpreting text is displayed'
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - VRI Interpreting Dashboard is shown for #{user_type}"}
      end
      # VRI Agent Dashboard
      if (permissions[:pages][:VideoInterpreting]=='R-VRIAgentDashboard')
        puts "Basic Test for VRI Agent Dashboard"
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to { driver.find_element(:xpath,'//*[@id="side-menu"]/li[2]/a/span').text.include?('Video Agent') }
        puts 'Video Agent is displayed'
        SeleniumHelper.try_to { driver.find_element(:xpath,'//*[@id="side-menu"]/li[2]/a/span').click }
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Video Agent')
        SeleniumHelper.wait_for_element(driver, 'Availability Status')
        puts 'Video Agent text is displayed'
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - VRI Agent Dashboard is shown for #{user_type}"}
      end
    rescue StandardError => e
      puts "error in permission: #{e.message}"
      puts e.backtrace.inspect # This method returns an array of strings that represent the call stack at the point that the exception was raised.
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "User Permission - Side Navigation Test - #{page} page is not shown for #{user_type}"}
    end
  end

  def self.test_unauthorized_page_permissions(driver, env, user_type, page)
    PortalTestHelper.navigate("#{env}",driver,user_type)
    # => key: TIDashboard, name: 'Telephone Interpreting'
    #puts "this is a page #{page}" # => key: TIDashboard, name: 'Telephone Interpreting'.
    permissions = PortalTestHelper.get_user_permissions(user_type)
    # check to see if user has NO permission, pages should not be shown on the side navigation
    # if user has no permission, navigate to pages the user does not have access to and check for not authorized error message
    puts page
    begin
      if (permissions[:pages][page[:key].to_sym] == '') && !pageShown = driver.find_elements(:link => page[:name]).size > 0
        puts pageShown
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to {PortalTestHelper.navigate("#{env}#{page[:link]}",driver,user_type) }
        sleep 2
        error_message_shown = SeleniumHelper.wait_for_element(driver, 'Not authorized!')
        puts "error message is displayed: #{error_message_shown}"
        sleep 2
        if error_message_shown == false
          PortalTestHelper.logout("#{env}",driver,user_type)
          return {passed: false, name: "User Permission - Side Navigation Test - #{page[:name]}: Not authorized error message is not shown for #{user_type} when it has no permission"}
        end
        if error_message_shown == true
          puts "User logs out"
          PortalTestHelper.logout("#{env}",driver,user_type)
          return {passed: true, name: "User Permission - Side Navigation Test - #{page[:name]}: Not authorized error message is shown for #{user_type} when it has no permission"}
        end
      else
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: false, name: "User Permission - Side Navigation Test -  #{page[:name]} page is shown when it has no permission #{user_type}"}
      end
    rescue StandardError => e
      puts "error in permission: #{e.message}"
      puts e.backtrace.inspect # This method returns an array of strings that represent the call stack at the point that the exception was raised.
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "User Permission - Side Navigation Test - #{page[:name]} page is not shown for #{user_type}"}
    end
    # check to see for users with permission if pages are displayed. no need to click, just check the side navigation.
    begin
      if (permissions[:pages][page[:key].to_sym] == 'R' || permissions[:pages][page[:key].to_sym] == 'RA' ||
          permissions[:pages][page[:key].to_sym] == 'RE' || permissions[:pages][page[:key].to_sym] == 'F' ||
          permissions[:pages][page[:key].to_sym] == 'FA' || permissions[:pages][page[:key].to_sym] == 'W' ||
          permissions[:pages][page[:key].to_sym] == 'WE') && page[:subname] == ""
        puts page
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to {driver.find_element(:link, page[:name]).text.include?(page[:name]) }
        sleep 1
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - #{page[:name]} page for #{user_type}"}
      end
      if (permissions[:pages][page[:key].to_sym] == 'R' || permissions[:pages][page[:key].to_sym] == 'RA' ||
          permissions[:pages][page[:key].to_sym] == 'RE' || permissions[:pages][page[:key].to_sym] == 'F' ||
          permissions[:pages][page[:key].to_sym] == 'FA' || permissions[:pages][page[:key].to_sym] == 'W' ||
          permissions[:pages][page[:key].to_sym] == 'WE') && page[:subname] != ""
        puts page
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to {driver.find_element(:link, page[:name]).text.include?(page[:name]) }
        SeleniumHelper.try_to {driver.find_element(:link, page[:name]).click }
        sleep 1
        #if there's subpages, it will check for the subpage but not click on it
        SeleniumHelper.try_to {driver.find_element(:link, page[:subname]).text.include?(page[:subname]) }
        sleep 1
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - #{page[:subname]} page for #{user_type}"}
      end
      # For Agent Dashboard
      if (permissions[:pages][page[:key].to_sym]=='R-AgentDashboard')
        puts "Basic Test for TI Agent Dashboard"
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to { driver.find_element(:link,'Dashboard').text.include?('Dashboard') }
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - TI Agent Dashboard for #{user_type}"}
      end
      # For Interpreter Dashboard
      if (permissions[:pages][:TIDashboard]=='R-TIDashboard')
        puts "Basic Test for TI Interpreter Dashboard"
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to { driver.find_element(:link,'Dashboard').text.include?('Dashboard') }
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - TI Interpreter Dashboard for #{user_type}"}
      end
      # VRI Interpreter Dashboard
      if (permissions[:pages][:VideoInterpreting]=='R-VRIInterpreterDashboard')
        puts "Basic Test for VRI Interpreter Dashboard"
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to { driver.find_element(:xpath,'//*[@id="side-menu"]/li[2]/a/span').text.include?('Video Interpreting') }
        sleep 1
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - VRI Interpreting Dashboard is shown for #{user_type}"}
      end
      # VRI Agent Dashboard
      if (permissions[:pages][:VideoInterpreting]=='R-VRIAgentDashboard')
        puts "Basic Test for VRI Agent Dashboard"
        sleep 1
        SeleniumHelper.wait_for_element(driver, 'Home')
        SeleniumHelper.try_to { driver.find_element(:xpath,'//*[@id="side-menu"]/li[2]/a/span').text.include?('Video Agent') }
        puts "User logs out"
        PortalTestHelper.logout("#{env}",driver,user_type)
        return {passed: true, name: "User Permission - Side Navigation Test - VRI Agent Dashboard is shown for #{user_type}"}
      end
    rescue StandardError => e
      puts "error in permission: #{e.message}"
      puts e.backtrace.inspect # This method returns an array of strings that represent the call stack at the point that the exception was raised.
      puts "User logs out"
      PortalTestHelper.logout("#{env}",driver,user_type)
      return {passed: false, name: "User Permission - Side Navigation Test - #{page} page is not shown for #{user_type}"}
    end
  end

end
