require "test_helper"

class SessionTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
    @session = Session.new(
      user: @user,
      ip_address: "127.0.0.1",
      user_agent: "Mozilla/5.0"
    )
  end

  # Validation tests
  test "should be valid with valid attributes" do
    assert @session.valid?
  end

  test "should require user" do
    @session.user = nil
    assert_not @session.valid?
    assert_includes @session.errors[:user], "must exist"
  end

  test "should allow nil ip_address" do
    @session.ip_address = nil
    assert @session.valid?
  end

  test "should allow nil user_agent" do
    @session.user_agent = nil
    assert @session.valid?
  end

  # Association tests
  test "should belong to user" do
    assert_instance_of User, @session.user
  end

  test "should be destroyed when user is destroyed" do
    @session.save!
    session_id = @session.id
    
    @user.destroy
    
    assert_nil Session.find_by(id: session_id)
  end

  # Integration tests
  test "should create session with all attributes" do
    session_count = Session.count
    
    session = Session.create!(
      user: @user,
      ip_address: "192.168.1.1",
      user_agent: "Test Browser"
    )
    
    assert_equal session_count + 1, Session.count
    assert session.persisted?
    assert_equal @user, session.user
    assert_equal "192.168.1.1", session.ip_address
    assert_equal "Test Browser", session.user_agent
  end

  test "should create session with minimal attributes" do
    session_count = Session.count
    
    session = Session.create!(
      user: @user
    )
    
    assert_equal session_count + 1, Session.count
    assert session.persisted?
    assert_equal @user, session.user
    assert_nil session.ip_address
    assert_nil session.user_agent
  end
end

