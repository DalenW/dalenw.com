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

end
