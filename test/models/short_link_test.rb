require "test_helper"

class ShortLinkTest < ActiveSupport::TestCase
  setup do
    @short_link = ShortLink.new(
      url: "https://example.com/some-long-path",
      code: "abc123",
      user: create(:user)
    )
  end

  test "should be valid with valid attributes" do
    assert @short_link.valid?
  end

  test "should require url" do
    @short_link.url = nil
    assert_not @short_link.valid?
    assert_includes @short_link.errors[:url], "can't be blank"
  end

  test "should require unique url" do
    existing_link = ShortLink.create!(
      url: @short_link.url,
      code: "different",
      user: create(:user)
    )

    assert_not @short_link.valid?
    assert_includes @short_link.errors[:url], "has already been taken"
  end

  test "should require code" do
    @short_link.code = nil
    assert_not @short_link.valid?
    assert_includes @short_link.errors[:code], "can't be blank"
  end

  test "should require unique code" do
    existing_link = ShortLink.create!(
      url: "https://different-url.com",
      code: @short_link.code,
      user: create(:user)
    )

    assert_not @short_link.valid?
    assert_includes @short_link.errors[:code], "has already been taken"
  end

  test "should allow valid code format" do
    valid_codes = %w[abc123 123456 abcdef]

    valid_codes.each do |code|
      @short_link.code = code
      assert @short_link.valid?, "#{code} should be valid"
    end
  end

  test "should not allow invalid code format" do
    invalid_codes = ["ABC123", "abc-123", "abc_123", "abc 123", "abc#123"]

    invalid_codes.each do |code|
      @short_link.code = code
      assert_not @short_link.valid?, "#{code} should not be valid"
      assert_includes @short_link.errors[:code], "is invalid"
    end
  end

  # Callback tests
  test "should create code on initialize if blank" do
    new_short_link = ShortLink.new(
      url: "https://example.com",
      user: create(:user)
    )
    assert_not_nil new_short_link.code
    assert_match(/\A[a-z0-9]+\z/, new_short_link.code)
  end

  test "should not override existing code on initialize" do
    new_short_link = ShortLink.new(
      url: "https://example.com",
      code: "custom123",
      user: create(:user)
    )
    assert_equal "custom123", new_short_link.code
  end

  # Method tests
  test "find_by_code should find short link by code" do
    @short_link.save!
    found_link = ShortLink.find_by(code: @short_link.code)
    assert_equal @short_link, found_link
  end

  test "find_by_code should return nil for non-existent code" do
    found_link = ShortLink.find_by(code: "nonexistent")
    assert_nil found_link
  end

  test "post_path should return admin post path when linkable is a post" do
    user = create(:user)
    post = create(:post, user: user)
    @short_link.linkable = post
    @short_link.save!
    
    expected_path = Rails.application.routes.url_helpers.admin_post_path(post.id)
    assert_equal expected_path, @short_link.post_path
  end

  test "link_path should return short link redirect path" do
    @short_link.save!
    expected_path = Rails.application.routes.url_helpers.short_link_redirect_path(@short_link.code)
    assert_equal expected_path, @short_link.link_path
  end

  test "link_url should return short link redirect url" do
    @short_link.save!
    expected_url = Rails.application.routes.url_helpers.short_link_redirect_url(@short_link.code)
    assert_equal expected_url, @short_link.link_url
  end

  # Association tests
  test "should belong to linkable polymorphically" do
    user = create(:user)
    post = create(:post, user: user)
    @short_link.linkable = post
    @short_link.save!
    
    assert_equal post, @short_link.linkable
    assert_equal "Post", @short_link.linkable_type
  end

  test "should allow linkable to be nil" do
    @short_link.linkable = nil
    assert @short_link.valid?
  end

  test "should belong to user" do
    assert_instance_of User, @short_link.user
  end

  # Integration tests
  test "should create short link with all required attributes" do
    user = create(:user)
    short_link_count = ShortLink.count
    
    short_link = ShortLink.create!(
      url: "https://new-example.com",
      code: "new123",
      user: user
    )
    
    assert_equal short_link_count + 1, ShortLink.count
    assert short_link.persisted?
    assert_not_nil short_link.code
    assert_equal "https://new-example.com", short_link.url
  end
end
