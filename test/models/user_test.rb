require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email_address: "test@example.com",
      password: "password123"
    )
  end

  # Validation tests
  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should require email_address" do
    @user.email_address = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email_address], "can't be blank"
  end

  test "should require unique email_address" do
    @user.save!
    duplicate_user = User.new(
      email_address: @user.email_address,
      password: "password123"
    )
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email_address], "has already been taken"
  end

  test "should require password" do
    @user.password = nil
    assert_not @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "should require password_digest" do
    @user.password_digest = nil
    assert_not @user.valid?
    assert_includes @user.errors[:password_digest], "can't be blank"
  end

  # Normalization tests
  test "should normalize email_address to lowercase" do
    @user.email_address = "TEST@EXAMPLE.COM"
    @user.save!
    assert_equal "test@example.com", @user.email_address
  end

  test "should strip whitespace from email_address" do
    @user.email_address = "  test@example.com  "
    @user.save!
    assert_equal "test@example.com", @user.email_address
  end

  test "should normalize email_address before validation" do
    @user.email_address = "  TEST@EXAMPLE.COM  "
    @user.valid?
    assert_equal "test@example.com", @user.email_address
  end

  # Association tests
  test "should have many sessions" do
    assert_respond_to @user, :sessions
    @user.save!
    session = @user.sessions.create!(ip_address: "127.0.0.1", user_agent: "Test")
    assert_includes @user.sessions, session
  end

  test "should destroy sessions when user is destroyed" do
    @user.save!
    session = @user.sessions.create!(ip_address: "127.0.0.1", user_agent: "Test")
    session_id = session.id
    
    @user.destroy
    
    assert_nil Session.find_by(id: session_id)
  end

  test "should have many posts" do
    assert_respond_to @user, :posts
    @user.save!
    post = @user.posts.create!(
      title: "Test Post",
      published_at: Time.current,
      status: :draft
    )
    assert_includes @user.posts, post
  end

  test "should have many short_links" do
    assert_respond_to @user, :short_links
    @user.save!
    short_link = @user.short_links.create!(
      url: "https://example.com",
      code: "test123"
    )
    assert_includes @user.short_links, short_link
  end

  # has_secure_password tests
  test "should authenticate with correct password" do
    @user.save!
    authenticated_user = User.authenticate_by(
      email_address: @user.email_address,
      password: "password123"
    )
    assert_equal @user, authenticated_user
  end

  test "should not authenticate with incorrect password" do
    @user.save!
    authenticated_user = User.authenticate_by(
      email_address: @user.email_address,
      password: "wrongpassword"
    )
    assert_nil authenticated_user
  end

  test "should not authenticate with incorrect email_address" do
    @user.save!
    authenticated_user = User.authenticate_by(
      email_address: "wrong@example.com",
      password: "password123"
    )
    assert_nil authenticated_user
  end

  test "should not authenticate with nil password" do
    @user.save!
    authenticated_user = User.authenticate_by(
      email_address: @user.email_address,
      password: nil
    )
    assert_nil authenticated_user
  end

  # Integration tests
  test "should create user with all required attributes" do
    user_count = User.count
    
    user = User.create!(
      email_address: "newuser@example.com",
      password: "securepassword"
    )
    
    assert_equal user_count + 1, User.count
    assert user.persisted?
    assert_not_nil user.password_digest
    assert_equal "newuser@example.com", user.email_address
  end
end
