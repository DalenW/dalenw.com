class Admin::ShortLinkController < AdminController
  before_action :find_short_link, except: [:index, :new, :create]
  before_action { @turbo_frame_tag = "short_link" }

  def index
    respond_to do |format|
      format.html
      format.json do
        ag_grid_json Current.user.short_links, params
      end
    end
  end

  def new
    @short_link = Current.user.short_links.new
  end

  def create
    safe_params = params.require(:create).permit(:url)

    url = safe_params[:url].strip

    @short_link = Current.user.short_links.create url: url

    redirect_to admin_short_link_path @short_link
  end

  def show
    # do something
  end

  def edit
    # do something
  end

  def update
    safe_params = params.require(:update).permit(:url)

    url = safe_params[:url].strip

    @short_link.assign_attributes(url:)

    if @short_link.save
      redirect_to admin_short_link_path @short_link
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_short_link
    @short_link = Current.user.short_links.find(params[:id])

    if @short_link.blank?
      @short_link = Current.user.short_links.find(params[:short_link_id])
    end
  end
end
