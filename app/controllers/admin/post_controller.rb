class Admin::PostController < AdminController
  before_action :find_post, except: [ :index, :new ]
  before_action { @turbo_frame_tag = "post" }

  def index
    @posts = Current.user.posts
  end

  def new
    @post = Post.new title: "A new post",
                     publish_at: Time.now,
                     status: 0,
                     user: Current.user
    @post.save

    redirect_to edit_admin_post_path @post
  end

  def show
    @markdown = Redcarpet::Markdown.new(FluffyCarpet, autolink: true, tables: true)
  end

  def edit
    # nothing
  end

  def update
    safe_params = params.require(:update).permit(
      :title,
      :path,
      :description,
      :content
    )

    safe_params.each do |key, value|
      safe_params[key] = value.strip if value.is_a? String
    end

    @post.assign_attributes safe_params

    if @post.invalid?
      flash[:error] = "Post could not be saved"
      return render :edit, status: :unprocessable_entity
    end

    if @post.save
      flash[:success] = "Post updated #{Time.now.to_s}"
      render :edit
    end
  end

  private
  def find_post
    @post = Post.find(params[:id])
  end
end
