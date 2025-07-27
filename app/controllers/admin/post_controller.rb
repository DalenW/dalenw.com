class Admin::PostController < AdminController
  before_action :find_post, except: [:index, :new]
  before_action { @turbo_frame_tag = "admin_post" }

  def index
    respond_to do |format|
      format.html
      format.json do
        ag_grid_json Current.user.posts, params
      end
    end
  end

  def new
    @post = Post.new title: "A new post",
                     published_at: Time.now,
                     status: 0,
                     user: Current.user
    @post.set_path
    @post.save

    redirect_to edit_admin_post_path @post
  end

  def show
    @markdown = Redcarpet::Markdown.new(FluffyCarpet, fenced_code_blocks: true, tables: true)
  end

  def edit
    # nothing
  end

  def update
    safe_params = params.require(:update).permit(
      :title,
      :description,
      :status,
      :published_at,
      :content,
      :image_upload
    )

    safe_params.each do |key, value|
      safe_params[key] = value.strip if value.is_a? String
    end

    @post.assign_attributes safe_params.except(:image_upload, :published_at)

    ### PUBLISHED AT
    if @post.published_at.strftime("%Y-%m-%d") != safe_params[:published_at].to_s
      @post.published_at = Date.strptime safe_params[:published_at].to_s, "%Y-%m-%d"
    else
      # puts "Same"
    end

    if safe_params[:image_upload].present?
      @post.images.attach safe_params[:image_upload]
    end

    if @post.invalid?
      flash[:error] = "Post could not be saved"
      return render :edit, status: :unprocessable_entity
    end

    if @post.save
      flash[:success] = "Post updated #{Time.now.to_s}"
      render :edit
    end
  end

  def set_cover_image
    attachment_id = params[:attachment_id]
    attachment = @post.images.find(attachment_id)

    if attachment.blank?
      flash[:error] = "No attachment found"
      return render :edit, status: :unprocessable_entity
    end

    unless attachment.image?
      flash[:error] = "Attachment #{attachment_id} is not an image"
      return render :edit, status: :unprocessable_entity
    end

    @post.cover_image.attach attachment.blob
    flash[:success] = "Cover image set #{Time.now}"
    render :edit
  end

  private

  def find_post
    @post = Post.find(params[:id].blank? ? params[:post_id] : params[:id])

    if @post.blank?
      puts "Post not found"
      render nothing: true, status: :not_found
    end

    @post
  end
end
