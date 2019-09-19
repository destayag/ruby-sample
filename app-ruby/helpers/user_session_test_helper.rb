module UserSessionTestHelper
    def self.change_password(new_password, confirm_password, current_password, driver)
        begin
            puts "User goes to Account Information tab"
            SeleniumHelper.wait_for_element(driver, "Account Information")
            puts "Input New Password"
            SeleniumHelper.try_to { driver.find_element(:name, 'user[password]').send_keys(new_password) }
            puts "Confirm New Password"
            SeleniumHelper.try_to { driver.find_element(:name, 'user[password_confirmation]').send_keys(confirm_password) }
            puts "Input Current Password"
            SeleniumHelper.try_to { driver.find_element(:name, 'user[current_password]').send_keys(current_password) }
            #Clicking Update button to save the password change.
            puts "Click Update button"
            sleep 1
            return true
        rescue StandardError => e
            puts "error resetting password in: #{e.message}"
            puts e.backtrace.inspect # This method returns an array of strings that represent the call stack at the point that the exception was raised.
            return false
        end
    end

    def self.login_test(login_email, login_password, driver)
        begin
            SeleniumHelper.try_to { driver.find_element(:id,"user_email").click }
            SeleniumHelper.try_to { driver.find_element(:id,"user_email").send_keys(login_email) }
            SeleniumHelper.try_to { driver.find_element(:id,"user_password").send_keys(login_password) }
            SeleniumHelper.try_to { driver.find_element(:name,"commit").click }
            sleep 1
            return true
        rescue StandardError => e
            puts "error logging in: #{e.message}"
            puts e.backtrace.inspect # This method returns an array of strings that represent the call stack at the point that the exception was raised.
            return false
        end
    end
end