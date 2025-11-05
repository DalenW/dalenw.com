require "test_helper"

class BlogControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @published_post = create(:post, :published, user: @user, published_at: 1.day.ago)
    @draft_post = create(:post, :draft, user: @user, published_at: 1.day.ago)
    @future_post = create(:post, :published, user: @user, published_at: 1.day.from_now)
    @archived_post = create(:post, :archived, user: @user, published_at: 2.days.ago)
  end

  test "should redirect to first published post when posts exist" do
    get blog_index_path
    
    assert_redirected_to blog_post_path(@published_post.path)
  end

  test "should render plain text when no posts exist" do
    Post.destroy_all
    
    get blog_index_path
    
    assert_response :success
    assert_equal "No posts found", response.body
  end

  test "should show published post by path" do
    get blog_post_path(@published_post.path)
    
    assert_response :success
    assert_equal @published_post, assigns(:post)
  end

  test "should increment views_count when viewing post" do
    initial_views = @published_post.views_count
    
    get blog_post_path(@published_post.path)
    
    @published_post.reload
    assert_equal initial_views + 1, @published_post.views_count
  end

  test "should find post by ID when path not found but ID in path" do
    # Create a post and then change its path to simulate a title change
    post = create(:post, :published, user: @user, published_at: 1.day.ago)
    original_path = post.path
    post.update!(title: "New Title")
    post.set_path
    post.save!
    
    # Try to access with old path - should find by ID at the end
    get blog_post_path(original_path)
    
    assert_response :success
    assert_equal post, assigns(:post)
  end

  test "should return 404 when post not found" do
    get blog_post_path("non-existent-path-123")
    
    assert_response :not_found
  end

  test "should only show published posts" do
    get blog_index_path
    
    # Should redirect to published post, not draft or archived
    assert_redirected_to blog_post_path(@published_post.path)
  end

  test "should only show posts with published_at in the past" do
    # Delete the published post from the past
    @published_post.destroy
    
    get blog_index_path
    
    # Should show "No posts found" since future_post is in the future
    assert_response :success
    assert_equal "No posts found", response.body
  end

  test "should order posts by published_at descending" do
    # Create multiple published posts
    old_post = create(:post, :published, user: @user, published_at: 3.days.ago, title: "Old Post")
    new_post = create(:post, :published, user: @user, published_at: 1.hour.ago, title: "New Post")
    
    get blog_index_path
    
    # Should redirect to the most recent post (new_post)
    assert_redirected_to blog_post_path(new_post.path)
  end
end
