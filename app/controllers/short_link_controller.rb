class ShortLinkController < ApplicationController
  allow_unauthenticated_access

  def redirect
    short_link = ShortLink.find_by_code(params[:code])

    return redirect_to root_path, alert: "Short link not found" if short_link.nil?

    if valid_redirect_url?(short_link.url)
      redirect_to short_link.url, allow_other_host: true, status: 301
    else
      redirect_to root_path, alert: "Invalid redirect URL"
    end
  end

  private

  def valid_redirect_url?(url)
    return false if url.blank?

    begin
      uri = URI.parse(url)

      # Allow relative URLs
      return true if uri.relative?

      # Only allow http/https schemes (blocks javascript:, data:, etc.)
      return false unless %w[http https].include?(uri.scheme&.downcase)

      # Block obviously suspicious patterns
      return false if uri.host&.include?("localhost") && Rails.env.production?
      return false if uri.host&.match?(/^\d+\.\d+\.\d+\.\d+$/) # Block raw IP addresses if desired

      true
    rescue URI::InvalidURIError
      false
    end
  end
end
