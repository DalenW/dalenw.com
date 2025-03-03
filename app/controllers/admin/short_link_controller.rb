class Admin::ShortLinkController < AdminController
  before_action :find_short_link, except: [ :index, :new, :create]
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
    # do something
  end

  def create
    safe_params = params.require(:create).permit(:url)

    url = safe_params[:url].strip

    @short_link = Current.user.short_links.create url: url

    redirect_to admin_short_link_path @short_link
  end


  private
  def find_short_link
    @short_link = Current.user.short_links.find(params[:id])

    if @short_link.blank?
      @short_link = Current.user.short_links.find(params[:short_link_id])
    end
  end
end
