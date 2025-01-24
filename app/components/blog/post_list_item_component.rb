# frozen_string_literal: true

class Blog::PostListItemComponent < ViewComponent::Base
  def initialize(post)
    @post = post
    @cover = @post.cover_image.present?
  end
end
