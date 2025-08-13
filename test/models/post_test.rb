require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email_address: "test@example.com", password: "password")
    @post = Post.new(
      title: "Test Post",
      published_at: Time.current,
      user: @user,
      status: :draft
    )
    @post.set_path
  end

  # Validation tests
  test "should be valid with valid attributes" do
    assert @post.valid?

    # put model errors
    puts @post.errors.full_messages
  end

  test "should require title" do
    @post.title = nil
    assert_not @post.valid?
    assert_includes @post.errors[:title], "can't be blank"
  end

  test "should require path" do
    @post.path = nil
    assert_not @post.valid?
    assert_includes @post.errors[:path], "can't be blank"
  end

  test "should require published_at" do
    @post.published_at = nil
    assert_not @post.valid?
    assert_includes @post.errors[:published_at], "can't be blank"
  end

  # Association tests
  test "should belong to user" do
    assert_instance_of User, @post.user
  end

  test "should have many attached images" do
    assert_respond_to @post, :images
  end

  test "should have one attached cover image" do
    assert_respond_to @post, :cover_image
  end

  test "should have one short link" do
    assert_respond_to @post, :short_link
  end

  # Enum tests
  test "should have status enum" do
    assert_respond_to @post, :status

    @post.draft!
    assert @post.draft?

    @post.published!
    assert @post.published?

    @post.archived!
    assert @post.archived?
  end

  test "should default to draft status" do
    new_post = Post.new
    assert_equal "draft", new_post.status
  end

  # Callback tests
  test "should set path before create" do
    @post.save!
    @post.set_path
    expected_path = "#{@post.published_at.year}-#{@post.published_at.month}-#{@post.published_at.day}-test-post-#{@post.id}"
    assert_equal expected_path, @post.path
  end

  test "should set path before update" do
    @post.save!
    original_path = @post.path

    @post.update!(title: "Updated Title")
    expected_path = "#{@post.published_at.year}-#{@post.published_at.month}-#{@post.published_at.day}-updated-title-#{@post.id}"
    assert_equal expected_path, @post.path
    assert_not_equal original_path, @post.path
  end

  # Method tests
  test "set_path should generate correct path format" do
    @post.title = "My Awesome Post"
    @post.published_at = Date.new(2024, 1, 15)
    @post.id = 123

    @post.set_path

    expected_path = "2024-1-15-my-awesome-post-123"
    assert_equal expected_path, @post.path
  end

  test "post_path should return admin post path" do
    @post.save!
    @post.set_path
    expected_path = Rails.application.routes.url_helpers.admin_post_path(@post.id)
    assert_equal expected_path, @post.post_path
  end

  # test "update_short_link should update short link url when present" do
  #   post = posts(:one)
  #   short_link = post.create_short_link!(url: "old-url")
  #
  #   post.update!(title: "New Title")
  #
  #   short_link.reload
  #   assert_equal post.path, short_link.url
  # end

  test "update_short_link should not error when short link is not present" do
    @post.save!
    assert_nil @post.short_link

    # This should not raise an error
    assert_nothing_raised do
      @post.update!(title: "New Title")
    end
  end

  # Integration tests
  test "should create post with all required attributes" do
    post_count = Post.count

    post = Post.new(
      title: "Integration Test Post",
      published_at: Time.current,
      user: @user,
      status: :published
    )
    post.set_path
    post.save

    assert_equal post_count + 1, Post.count
    assert post.persisted?
    assert_not_nil post.path
    assert post.published?
  end
end
