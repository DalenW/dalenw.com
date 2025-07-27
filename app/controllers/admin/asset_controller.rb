class Admin::AssetController < AdminController
  before_action :find_asset, except: [:index]
  before_action { @turbo_frame_tag = "admin_asset" }

  def index
    def index
      respond_to do |format|
        format.html
        format.json do
          ag_grid_json ActiveStorage::Attachment.all, params
        end
      end
    end
  end

  def show
    @blob = @asset.blob
    @record = @asset.record if @asset.record
  end

  def destroy
    filename = @asset.blob.filename.to_s
    redirect_path = params[:redirect_to] || admin_asset_index_path

    # Purge the attachment (removes both attachment record and blob/file)
    @asset.purge

    flash[:success] = "Asset '#{filename}' deleted successfully"

    redirect_to redirect_path
  end

  private

  def find_asset
    @asset = ActiveStorage::Attachment.find_by_id(params[:id].blank? ? params[:asset_id] : params[:id])

    if @asset.blank?
      puts "Asset not found"
      return redirect_to admin_asset_index_path
    end

    @asset
  end
end
