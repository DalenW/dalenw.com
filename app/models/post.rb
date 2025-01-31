class Post < ApplicationRecord
  ### ASSOCIATIONS
  # ====================================================================================================================
  belongs_to :user

  has_many_attached :images
  has_one_attached :cover_image

  ### ENUMS
  # ====================================================================================================================
  enum :status, {
    draft: 0,
    published: 1,
    archived: 2
  }


  ### CALLBACKS
  # ====================================================================================================================

  validates :title, presence: true
  validates :path, presence: true
  validates :published_at, presence: true


  ### CALLBACKS
  # ====================================================================================================================

  before_create :set_path
  before_update :set_path


  ### METHODS
  # ====================================================================================================================

  def set_path
    assign_attributes path: "#{published_at.year}-#{published_at.month}-#{published_at.day}-#{title.parameterize}-#{id}"
    puts self.path
  end
end
