require "test_helper"

class ShortLinkControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @short_link = ShortLink.create!(
      url: "https://example.com/path",
      code: "test123",
      user: @user
    )
  end

  test "should redirect to short link url with valid code" do
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to @short_link.url
    assert_response :moved_permanently
  end

  test "should redirect to root with alert when short link not found" do
    get short_link_redirect_path("nonexistent")
    
    assert_redirected_to root_path
    assert_equal "Short link not found", flash[:alert]
  end

  test "should allow http URLs" do
    @short_link.update!(url: "http://example.com")
    
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to "http://example.com"
  end

  test "should allow https URLs" do
    @short_link.update!(url: "https://example.com")
    
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to "https://example.com"
  end

  test "should allow relative URLs" do
    @short_link.update!(url: "/blog/post")
    
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to "/blog/post"
  end

  test "should block javascript URLs" do
    @short_link.update!(url: "javascript:alert('xss')")
    
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to root_path
    assert_equal "Invalid redirect URL", flash[:alert]
  end

  test "should block data URLs" do
    @short_link.update!(url: "data:text/html,<script>alert('xss')</script>")
    
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to root_path
    assert_equal "Invalid redirect URL", flash[:alert]
  end

  test "should block blank URLs" do
    @short_link.update!(url: "")
    
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to root_path
    assert_equal "Invalid redirect URL", flash[:alert]
  end

  test "should block localhost URLs in production" do
    Rails.env.stub(:production?, true) do
      @short_link.update!(url: "http://localhost:3000")
      
      get short_link_redirect_path(@short_link.code)
      
      assert_redirected_to root_path
      assert_equal "Invalid redirect URL", flash[:alert]
    end
  end

  test "should allow localhost URLs in development" do
    Rails.env.stub(:production?, false) do
      @short_link.update!(url: "http://localhost:3000")
      
      get short_link_redirect_path(@short_link.code)
      
      assert_redirected_to "http://localhost:3000"
    end
  end

  test "should handle invalid URI gracefully" do
    @short_link.update!(url: "not a valid url!")
    
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to root_path
    assert_equal "Invalid redirect URL", flash[:alert]
  end

  test "should handle URLs with query parameters" do
    @short_link.update!(url: "https://example.com?param=value&other=123")
    
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to "https://example.com?param=value&other=123"
  end

  test "should handle URLs with fragments" do
    @short_link.update!(url: "https://example.com#section")
    
    get short_link_redirect_path(@short_link.code)
    
    assert_redirected_to "https://example.com#section"
  end
end
