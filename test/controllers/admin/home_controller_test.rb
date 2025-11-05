require "test_helper"

class Admin::HomeControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    authenticate_user(@user)
  end

  def authenticate_user(user)
    session = user.sessions.create!(ip_address: "127.0.0.1", user_agent: "Test")
    cookies.signed.permanent[:session_id] = session.id
    Current.session = session
  end

  test "should get index" do
    get admin_home_path
    
    assert_response :success
  end

  test "should require authentication" do
    cookies.delete(:session_id)
    Current.session = nil
    
    get admin_home_path
    
    assert_redirected_to new_session_path
  end
end
