# frozen_string_literal: true

class PostLinks < ActiveRecord::Migration[8.0]
  def up
    Post.all.each do |post|
      short_link = ShortLink.create(
        url: Rails.application.routes.url_helpers.blog_post_path(post.path),
        user: post.user,
        linkable: post,
        enabled: true
      )
    end
  end

  def down
    ShortLink.where(linkable_type: "Post").destroy_all
  end
end
