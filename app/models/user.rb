class User < ApplicationRecord
  has_secure_password

  ### ASSOCIATIONS
  # ====================================================================================================================
  has_many :sessions, dependent: :destroy
  has_many :posts
  has_many :short_links

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
