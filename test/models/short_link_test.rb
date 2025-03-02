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
end
