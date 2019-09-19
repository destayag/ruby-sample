module OnsiteInterpretingTestHelper
    def self.view_onsite_list(user_type, driver)
      begin
            puts "Check if Search section is displayed"
            driver.find_element(:xpath, '//*[@id="search_value"]')
            sleep 1
            puts "Check if Search button is displayed"
            driver.find_element(:xpath, '//*[@id="search_button"]')
            sleep 1
            puts "Checking if Show entries section is displayed"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_table_length"]')
            puts "Check if Details button is displayed"
            driver.find_element(:link, 'Details')
            sleep 1
            puts "Checking for Permissions"
            permission = PortalTestHelper.get_user_permissions(user_type)
            if permission[:pages][:OnsiteInterpreting] == 'W' || permission[:pages][:OnsiteInterpreting] == 'WA'|| permission[:pages][:OnsiteInterpreting] == 'WE' || permission[:pages][:OnsiteInterpreting] == 'F' || permission[:pages][:OnsiteInterpreting] == 'FE' || permission[:pages][:OnsiteInterpreting] ==  'FA'
                  puts "Check if Edit button is displayed"
                  if driver.find_elements(:link, 'Edit').size < 0
                        puts "Edit button is not displayed"
                        return false
                  else
                        puts "Edit button is displayed"
                        sleep 1
                  end
                  puts "Checking if Add Onsite Appointment button is displayed"
                  if driver.find_elements(:link, 'Add On-Site Appointment').size < 0
                        puts "Add button is not displayed"
                        return false
                  else
                        puts "Add button is displayed"
                        sleep 1  
                  end
            end
            if permission[:pages][:OnsiteInterpreting] == 'F' || permission[:pages][:OnsiteInterpreting] == 'FE' || permission[:pages][:OnsiteInterpreting] ==  'FA'
                  puts "Check if Cancel button is displayed"
                  if driver.find_elements(:link, 'Cancel').size < 0
                        return false
                        puts "Cancel button is not displayed"
                        sleep 1
                  else
                        puts "Cancel button is  displayed"
                        sleep 1
                  end
            end
            puts "Checking if Show entries dropdown is displayed"
            driver.find_element(:class, 'select2-selection__rendered')
            sleep 1
            puts "Checking for the pagination links"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_table_paginate"]/ul')
            sleep 1

            if permission[:pages][:OnsiteInterpreting] == 'WE' || permission[:pages][:OnsiteInterpreting] == 'WA' || permission[:pages][:OnsiteInterpreting] == 'FE' || permission[:pages][:OnsiteInterpreting] == 'FA' || permission[:pages][:OnsiteInterpreting] == 'RE' || permission[:pages][:OnsiteInterpreting] == 'RA'    
                  puts "Checking if Export buttons are displayed"
                  driver.find_element(:xpath, '//*[@id="main_target"]/div[3]/div/div/div[2]/div[3]')
                  sleep 1
            end
            return true
      rescue StandardError => e
            puts "error viewing onsite list in: #{e.message}"
            puts e.backtrace.inspect 
            return false
      end
    end

      def self.add_onsite_request(user_type, driver)
        begin
            puts "Inputting onsite request data"
            puts "Inputting language"
            driver.find_element(:xpath, '//*[@id="new_onsite_interpreting"]/div[1]/div[2]/span[1]/span[1]/span').send_keys("Pampangan")
            driver.find_element(:xpath,'//*[@id="new_onsite_interpreting"]/div[1]/div[2]/span[1]/span[1]/span/ul/li/input').send_keys:return
            sleep 1
            puts "Inputting start date"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_start_date"]').clear      
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_start_date"]').send_keys("05/15/2019")
            driver.find_element(:xpath, '//*[@id="new_onsite_interpreting"]/div[4]/div[1]/label').click
            sleep 1
            puts "Inputting timezone"
            driver.find_element(:xpath, '//*[@id="select2-onsite_interpreting_time_zone-container"]').click
            driver.find_element(:xpath, '/html/body/span/span/span[1]/input').send_keys("(GMT-05:00) Eastern Time (US & Canada)")
            driver.find_element(:xpath, '/html/body/span/span/span[1]/input').send_keys:return
            puts "Inputting start time"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_start_time"]').send_keys("12:30 PM")
            puts "Inputting estimated end date"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_end_date"]').send_keys("05/15/2019")
            driver.find_element(:xpath, '//*[@id="new_onsite_interpreting"]/div[7]/div[1]/label').click
            puts "Inputting estimated end time"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_end_time"]').send_keys("5:30 PM")
            puts "Inputting patient name and MRN"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_mrn"]').send_keys("Anne Tester")
            puts "Inputting appointment description"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_nature"]').send_keys("Test for Adding Onsite Request")
            puts "Inputting your name"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_requestor_name"]').send_keys("Jack Sparrow")
            puts "Inputting your email"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_requestor_email"]').send_keys("des@helloglobo.com")  
            puts "Inputting appointment contact"     
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_appointment_contact"]').send_keys("Appointment Contact")  
            puts "Inputting appointment contact email"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_appointment_contact_email"]').send_keys("appointment@globo.email") 
            puts "Inputting appointment contact phone"   
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_requestor_phone_number"]').send_keys("+1 (484) 539-9130") 
            puts "Selecting location"
            driver.find_element(:xpath, '//*[@id="select2-onsite_interpreting_address_table_id-container"]').click
            driver.find_element(:xpath, '/html/body/span/span/span[1]/input').send_keys("Location 1")   
            driver.find_element(:xpath, '/html/body/span/span/span[1]/input').send_keys:return
            if driver.find_elements(:xpath, '//*[@id="questions"]/div[1]/div/div[1]/label').size > 0
                  puts "Checking if onsite interpreting has mandatory fields custom fields"
                  driver.find_element(:xpath, '//*[@id="questions"]/div[1]/div/div[2]/input').send_keys("Single Line mandatory")                          
                  driver.find_element(:xpath, '//*[@id="questions"]/div[3]/div/div[2]/textarea').send_keys("Multiple Line mandatory") 
                  driver.find_element(:xpath, '//*[@id="questions"]/div[5]/div/div[2]/span[1]/span[1]/span').send_keys("Mandatory Option 2 - Mandatory Option 2") 
                  driver.find_element(:xpath, '/html/body/span/span/span[1]/input').send_keys:return
                  sleep 1
            end
            puts "Clicking Submit button to save the onsite request"
            driver.find_element(:name, 'commit').click
            sleep 1
            if driver.find_elements(:id => 'confirmation-required').size > 0
                  puts "Confirmation button show. Clicking Confirm button"
                  driver.find_element(:name, 'confirmation_required').click
            else
                  puts "Waiting onsite request view page"
                  SeleniumHelper.wait_for_element(driver, 'Automation Test Company') 
                  sleep 1
            end 
            return true
        rescue StandardError => e
            puts "error adding onsite request in: #{e.message}"
            puts e.backtrace.inspect 
            return false
        end
    end
    

    def self.edit_onsite_request(user_type, driver)
        begin
            puts "Making changes on onsite request data"
            puts "Editing Start Date"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_start_date"]').clear      
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_start_date"]').send_keys("05/31/2019")
            driver.find_element(:xpath, '/html/body/div[7]/div[1]/table/tbody/tr[3]/td[6]').click
            sleep 1
            puts "Editing Start Time"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_start_time"]').clear
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_start_time"]').send_keys("8:45 AM")
            puts "Editing End Date"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_end_date"]').clear
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_end_date"]').send_keys("05/31/2019")
            puts "Editing End Time"
            driver.find_element(:xpath, '/html/body/div[7]/div[1]/table/tbody/tr[3]/td[6]').click
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_end_time"]').clear
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_end_time"]').send_keys("5:30 PM")
            puts "Editing patient name and MRN"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_mrn"]').clear
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_mrn"]').send_keys("Anne Tester-edit")
            puts "Editing appointment description"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_nature"]').clear
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_nature"]').send_keys("Test for Adding Onsite Request - edit")
            puts "Editing your name"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_requestor_name"]').clear
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_requestor_name"]').send_keys("Jack Sparrow - edit")
            puts "Editing your email"
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_requestor_email"]').clear
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_requestor_email"]').send_keys("des-edit@helloglobo.com")    
            puts "Editing appointment contact"  
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_appointment_contact"]').clear
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_appointment_contact"]').send_keys("Appointment Contact - edit")  
            puts "Editing appointment contact email"  
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_appointment_contact_email"]').clear
            driver.find_element(:xpath, '//*[@id="onsite_interpreting_appointment_contact_email"]').send_keys("appointment-edit@globo.email")   
            puts "Editing Location"   
            driver.find_element(:xpath, '//*[@id="select2-onsite_interpreting_address_table_id-container"]').click
            driver.find_element(:xpath, '/html/body/span/span/span[1]/input').send_keys("Location 2")   
            driver.find_element(:xpath, '/html/body/span/span/span[1]/input').send_keys:return
            company_users = ['company_onsite_user_one', 'company_user_one']
            if company_users.include?(user_type)
                  puts "Editing mandatory fields and custom fields"
                  sleep 1
                  driver.find_element(:xpath, '//*[@id="questions"]/div[1]/div/div[2]/input').clear
                  driver.find_element(:xpath, '//*[@id="questions"]/div[1]/div/div[2]/input').send_keys("Single Line mandatory - edit")
                  driver.find_element(:xpath, '//*[@id="questions"]/div[3]/div/div[2]/textarea').clear                          
                  driver.find_element(:xpath, '//*[@id="questions"]/div[3]/div/div[2]/textarea').send_keys("Multiple Line mandatory - edit") 
                  driver.find_element(:xpath, '//*[@id="questions"]/div[5]/div/div[2]/span[1]/span[1]/span').send_keys("Mandatory Option 1 - Mandatory Option 1") 
                  driver.find_element(:xpath, '/html/body/span/span/span[1]/input').send_keys:return
                  sleep 1
            end
            puts "Clicking Submit button to save the changes on the onsite request"
            driver.find_element(:name, 'commit').click
            sleep 1
            if driver.find_elements(:id => 'confirmation-required').size > 0
                  puts "Confirmation button show. Clicking Confirm button"
                  driver.find_element(:name, 'confirmation_required').click
            else
                  puts "Waiting onsite request view page"
                  SeleniumHelper.wait_for_element(driver, 'Project Number') 
                  sleep 1
            end 
            return true
        rescue StandardError => e
            puts "error editing onsite request in: #{e.message}"
            puts e.backtrace.inspect 
            return false
        end
    end
    
end
