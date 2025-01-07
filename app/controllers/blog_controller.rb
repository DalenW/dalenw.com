class BlogController < ApplicationController
  allow_unauthenticated_access
  before_action { @turbo_frame_tag = "post" }
  def index
    @posts = Post.all
    @post = @posts.last
    @markdown = Redcarpet::Markdown.new(FluffyCarpet, fenced_code_blocks: true, tables: true)

    render "blog/post"
  end

  def post
    @posts = Post.all
    @post = Post.find_by path: params[:path]

    if @post.nil?
      return render nothing: true, status: :not_found
    end

    # @turbo_frame_tag = "post_#{@post.id}"
    @markdown = Redcarpet::Markdown.new(FluffyCarpet, fenced_code_blocks: true, tables: true)
  end
end
