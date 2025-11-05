require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_path
    
    assert_response :success
  end

  test "should get contact" do
    get contact_path
    
    assert_response :success
  end
end
