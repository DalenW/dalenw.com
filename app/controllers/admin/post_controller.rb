class Admin::PostController < AdminController
  before_action :find_post, except: [ :index, :new ]
  before_action { @turbo_frame_tag = "post" }

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new title: "A new post",
                     publish_at: Time.now,
                     status: 0,
                     user: Current.user
    @post.save

    redirect_to edit_admin_post_path @post
  end


  def find_post
    @post = Post.find(params[:id])
  end
end
