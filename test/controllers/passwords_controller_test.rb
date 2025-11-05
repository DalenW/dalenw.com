require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email_address: "test@example.com", password: "password123")
  end

  test "should get new password page" do
    get new_password_path
    
    assert_response :success
  end

  test "should send reset email for existing user" do
    assert_enqueued_with(job: ActionMailer::MailDeliveryJob) do
      post passwords_path, params: {
        email_address: @user.email_address
      }
    end
    
    assert_redirected_to new_session_path
    assert_equal "Password reset instructions sent (if user with that email address exists).", flash[:notice]
  end

  test "should not send reset email for non-existent user" do
    assert_no_enqueued_jobs(only: ActionMailer::MailDeliveryJob) do
      post passwords_path, params: {
        email_address: "nonexistent@example.com"
      }
    end
    
    # Should still show success message for security (prevent user enumeration)
    assert_redirected_to new_session_path
    assert_equal "Password reset instructions sent (if user with that email address exists).", flash[:notice]
  end

  test "should get edit password page with valid token" do
    token = @user.password_reset_token
    
    get edit_password_path(token)
    
    assert_response :success
    assert_equal @user, assigns(:user)
  end

  test "should redirect to new password page with invalid token" do
    get edit_password_path("invalid-token")
    
    assert_redirected_to new_password_path
    assert_equal "Password reset link is invalid or has expired.", flash[:alert]
  end

  test "should update password with valid token and matching passwords" do
    token = @user.password_reset_token
    
    patch password_path(token), params: {
      password: "newpassword123",
      password_confirmation: "newpassword123"
    }
    
    assert_redirected_to new_session_path
    assert_equal "Password has been reset.", flash[:notice]
    
    # Verify password was changed
    @user.reload
    assert @user.authenticate("newpassword123")
    assert_not @user.authenticate("password123")
  end

  test "should not update password with non-matching passwords" do
    token = @user.password_reset_token
    
    patch password_path(token), params: {
      password: "newpassword123",
      password_confirmation: "differentpassword"
    }
    
    assert_redirected_to edit_password_path(token)
    assert_equal "Passwords did not match.", flash[:alert]
    
    # Verify password was not changed
    @user.reload
    assert @user.authenticate("password123")
    assert_not @user.authenticate("newpassword123")
  end

  test "should not update password with invalid token" do
    patch password_path("invalid-token"), params: {
      password: "newpassword123",
      password_confirmation: "newpassword123"
    }
    
    assert_redirected_to new_password_path
    assert_equal "Password reset link is invalid or has expired.", flash[:alert]
  end

  test "should handle email address normalization" do
    assert_enqueued_with(job: ActionMailer::MailDeliveryJob) do
      post passwords_path, params: {
        email_address: "  TEST@EXAMPLE.COM  "
      }
    end
    
    assert_redirected_to new_session_path
  end
end

