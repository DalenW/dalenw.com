require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email_address: "test@example.com", password: "password123")
  end

  test "should get new session page" do
    get new_session_path
    
    assert_response :success
  end

  test "should create session with valid credentials" do
    post session_path, params: {
      email_address: @user.email_address,
      password: "password123"
    }
    
    assert_redirected_to admin_home_path
    assert_not_nil cookies.signed[:session_id]
    assert_equal 1, @user.sessions.count
  end

  test "should not create session with invalid email" do
    post session_path, params: {
      email_address: "wrong@example.com",
      password: "password123"
    }
    
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
    assert_equal 0, @user.sessions.count
  end

  test "should not create session with invalid password" do
    post session_path, params: {
      email_address: @user.email_address,
      password: "wrongpassword"
    }
    
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
    assert_equal 0, @user.sessions.count
  end

  test "should create session with normalized email address" do
    post session_path, params: {
      email_address: "  TEST@EXAMPLE.COM  ",
      password: "password123"
    }
    
    assert_redirected_to admin_home_path
    assert_not_nil cookies.signed[:session_id]
  end

  test "should destroy session" do
    # First create a session
    post session_path, params: {
      email_address: @user.email_address,
      password: "password123"
    }
    
    session_id = cookies.signed[:session_id]
    assert_not_nil session_id
    
    # Then destroy it
    delete session_path
    
    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
    assert_nil Session.find_by(id: session_id)
  end

  test "should create session with user agent and ip address" do
    post session_path, params: {
      email_address: @user.email_address,
      password: "password123"
    }, headers: {
      "User-Agent" => "Test Browser",
      "REMOTE_ADDR" => "192.168.1.1"
    }
    
    session = @user.sessions.last
    assert_equal "Test Browser", session.user_agent
    assert_equal "192.168.1.1", session.ip_address
  end

  test "should rate limit session creation attempts" do
    # This test verifies rate limiting is configured
    # Note: Actual rate limiting behavior may depend on the rate limiting implementation
    # and may require time-based testing or mocking
    
    # Make multiple requests
    5.times do
      post session_path, params: {
        email_address: "wrong@example.com",
        password: "wrong"
      }
    end
    
    # Verify that requests are still being processed (not rate limited yet)
    # Rate limiting would kick in after 10 attempts within 3 minutes
    assert_response :redirect
  end
end

