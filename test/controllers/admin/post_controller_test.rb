require "test_helper"

class Admin::PostControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @post = create(:post, user: @user)
    authenticate_user(@user)
  end

  def authenticate_user(user)
    session = user.sessions.create!(ip_address: "127.0.0.1", user_agent: "Test")
    cookies.signed.permanent[:session_id] = session.id
    Current.session = session
  end

  test "should get index" do
    get admin_post_index_path
    
    assert_response :success
  end

  test "should get index as json" do
    get admin_post_index_path, params: { format: :json }
    
    assert_response :success
    assert_equal "application/json", response.content_type
  end

  test "should create new post" do
    post_count = Post.count
    
    post admin_post_index_path, params: { format: :html }
    
    assert_equal post_count + 1, Post.count
    new_post = Post.last
    assert_redirected_to edit_admin_post_path(new_post)
    assert_equal "A new post", new_post.title
    assert_equal @user, new_post.user
  end

  test "should show post" do
    get admin_post_path(@post)
    
    assert_response :success
    assert_equal @post, assigns(:post)
  end

  test "should get edit post" do
    get edit_admin_post_path(@post)
    
    assert_response :success
    assert_equal @post, assigns(:post)
  end

  test "should update post with valid attributes" do
    patch admin_post_path(@post), params: {
      update: {
        title: "Updated Title",
        description: "Updated description",
        content: "Updated content",
        status: "published",
        published_at: "2024-01-15"
      }
    }
    
    @post.reload
    assert_equal "Updated Title", @post.title
    assert_equal "Updated description", @post.description
    assert_equal "Updated content", @post.content
    assert @post.published?
    assert_response :success
    assert_match(/Post updated/, flash[:success])
  end

  test "should update published_at when date changes" do
    new_date = "2024-06-15"
    patch admin_post_path(@post), params: {
      update: {
        published_at: new_date,
        title: @post.title
      }
    }
    
    @post.reload
    assert_equal Date.parse(new_date), @post.published_at.to_date
  end

  test "should not update published_at when date unchanged" do
    original_date = @post.published_at
    patch admin_post_path(@post), params: {
      update: {
        published_at: original_date.strftime("%Y-%m-%d"),
        title: "Updated Title"
      }
    }
    
    @post.reload
    assert_equal original_date.to_date, @post.published_at.to_date
  end

  test "should attach image when image_upload provided" do
    # Skip this test if fixture file doesn't exist - it's optional
    skip "Image fixture file not available" unless File.exist?(Rails.root.join("test/fixtures/files/image.jpg"))
    
    image = fixture_file_upload("files/image.jpg", "image/jpeg")
    
    patch admin_post_path(@post), params: {
      update: {
        title: @post.title,
        image_upload: image
      }
    }
    
    @post.reload
    assert @post.images.attached?
    assert_equal 1, @post.images.count
  end

  test "should render edit with errors when post invalid" do
    patch admin_post_path(@post), params: {
      update: {
        title: nil, # Invalid - title is required
        description: "Description"
      }
    }
    
    assert_response :unprocessable_entity
    assert_equal "Post could not be saved", flash[:error]
  end

  test "should strip whitespace from string attributes" do
    patch admin_post_path(@post), params: {
      update: {
        title: "  Trimmed Title  ",
        description: "  Trimmed Description  ",
        content: "  Trimmed Content  "
      }
    }
    
    @post.reload
    assert_equal "Trimmed Title", @post.title
    assert_equal "Trimmed Description", @post.description
    assert_equal "Trimmed Content", @post.content
  end

  test "should set cover image" do
    # Skip this test if fixture file doesn't exist - it's optional
    skip "Image fixture file not available" unless File.exist?(Rails.root.join("test/fixtures/files/image.jpg"))
    
    # First attach an image
    image = fixture_file_upload("files/image.jpg", "image/jpeg")
    @post.images.attach(image)
    attachment = @post.images.first
    
    post set_cover_image_admin_post_path(@post, attachment_id: attachment.id)
    
    @post.reload
    assert @post.cover_image.attached?
    assert_equal image.blob.filename, @post.cover_image.blob.filename
    assert_response :success
    assert_match(/Cover image set/, flash[:success])
  end

  test "should not set cover image when attachment not found" do
    post set_cover_image_admin_post_path(@post, attachment_id: 99999)
    
    assert_response :unprocessable_entity
    assert_equal "No attachment found", flash[:error]
  end

  test "should require authentication" do
    cookies.delete(:session_id)
    
    get admin_post_index_path
    
    assert_redirected_to new_session_path
  end

  test "should only allow user to access their own posts" do
    other_user = create(:user)
    other_post = create(:post, user: other_user)
    
    get admin_post_path(other_post)
    
    # Should either redirect or raise error - depends on implementation
    # This test verifies authorization is checked
    assert_response :not_found
  end
end
