class BlogController < ApplicationController
  allow_unauthenticated_access
  before_action { @turbo_frame_tag = "post" }
  before_action { @posts = Post.where(status: Post.statuses[:published]).order(published_at: :desc) }
  def index
    @post = @posts.last

    render "blog/post"
  end

  def post
    @post = Post.find_by path: params[:path]

    if @post.present?
      return
    end

    # if we're here, then the post title probably changed.
    # get the post ID as the last digit in the path

    post_id = params[:path].to_s.split("-").last.to_i

    if post_id.positive?
      @post = @posts.find post_id
      return
    end

    render nothing: true, status: :not_found

  end
end
