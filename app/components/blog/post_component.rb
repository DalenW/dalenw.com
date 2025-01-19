# frozen_string_literal: true

class Blog::PostComponent < ViewComponent::Base
  def initialize(post)
    @post = post
    @markdown = Redcarpet::Markdown.new(FluffyCarpet, fenced_code_blocks: true, tables: true)
  end
end
