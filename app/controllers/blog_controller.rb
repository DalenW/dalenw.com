class BlogController < ApplicationController
  allow_unauthenticated_access
  before_action { @turbo_frame_tag = "post" }
  before_action :posts

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

  private
  def posts
    # TODO: Verify that this uses the same timezone as the published at field so it's accurate
    @posts = Post.where(status: Post.statuses[:published], published_at: ...Time.now).order(published_at: :desc)
  end
end
