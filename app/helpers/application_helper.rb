module ApplicationHelper
  def get_ip_address
    ip_address = request.headers["CF-Connecting-IP"]
    ip_address = request.remote_ip if ip_address.blank?
    ip_address
  end
end
