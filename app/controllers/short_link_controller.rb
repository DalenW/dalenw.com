class ShortLinkController < ApplicationController
  allow_unauthenticated_access

  def redirect
    short_link = ShortLink.find_by_code(params[:code])

    redirect_to short_link.url
  end
end
