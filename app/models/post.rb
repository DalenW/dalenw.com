class Post < ApplicationRecord
  ### ASSOCIATIONS
  # ====================================================================================================================
  belongs_to :user

  has_many_attached :images
  has_one_attached :cover_image

  has_one :short_link, dependent: :destroy, as: :linkable

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

  after_commit :update_short_link


  ### METHODS
  # ====================================================================================================================

  def set_path
    assign_attributes path: "#{published_at.year}-#{published_at.month}-#{published_at.day}-#{title.parameterize}-#{id}"
    puts self.path
  end

  def update_short_link
    short_link.url = self.path
    short_link.save
  end
end
