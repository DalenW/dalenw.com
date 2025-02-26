class Admin::PostController < AdminController
  before_action :find_post, except: [ :index, :new ]
  before_action { @turbo_frame_tag = "post" }

  def index
    respond_to do |format|
      format.html
      format.json do
        # Handle server-side pagination, sorting, and filtering
        # page_size = params[:endRow].to_i - params[:startRow].to_i
        # page = (params[:startRow].to_i / page_size) + 1

        query = Current.user.posts

        # Handle sorting
        if params[:sortModel].present?
          params[:sortModel] = JSON.parse params[:sortModel].to_s
          params[:sortModel].each do |sort|
            query = query.order("#{sort[:colId]} #{sort[:sort]}")
          end
        end

        # Handle filtering
        if params[:filterModel].present?
          params[:filterModel] = JSON.parse params[:filterModel].to_s
          params[:filterModel].each do |field, filter|
            next unless filter[:filter].present?
            query = query.where("#{field} ILIKE ?", "%#{filter[:filter]}%")
          end
        end

        total = query.count
        posts = query.offset(params[:startRow]).limit(params[:endRow].to_i - params[:startRow].to_i)

        render json: {
          rows: posts,
          lastRow: total
        }
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
