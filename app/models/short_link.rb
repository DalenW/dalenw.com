class ShortLink < ApplicationRecord
  ### ASSOCIATIONS
  # ====================================================================================================================

  belongs_to :linkable, polymorphic: true, optional: true
  belongs_to :user

  ### VALIDATIONS
  # ====================================================================================================================

  validates :url,
            presence: true,
            uniqueness: true

  # validate code, but only lowercase letters and numbers
  validates :code,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A[a-z0-9]+\z/
            }


  ### METHODS
  # ====================================================================================================================

  after_initialize :create_code
  def create_code
    self.code = SecureRandom.base36(6) if self.code.blank?
  end

  def post_path
    Rails.application.routes.url_helpers.admin_post_path self.linkable_id
  end
end
