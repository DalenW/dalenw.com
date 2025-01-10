class Post < ApplicationRecord
  ### ASSOCIATIONS
  # ====================================================================================================================
  belongs_to :user

  has_many_attached :images

  ### ENUMS
  # ====================================================================================================================
  enum :status, {
    draft: 0,
    published: 1
  }


  ### CALLBACKS
  # ====================================================================================================================

  validates :title, presence: true
  validates :path, presence: true


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
