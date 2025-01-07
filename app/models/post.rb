class Post < ApplicationRecord
  ### ASSOCIATIONS
  # ====================================================================================================================
  belongs_to :user

  ### ENUMS
  # ====================================================================================================================
  enum :status, {
    draft: 0,
    published: 1
  }

  ### CALLBACKS
  # ====================================================================================================================

  before_update :set_path


  ### METHODS
  # ====================================================================================================================


  private
  def set_path
    assign_attributes path: "#{published_at.year}-#{published_at.month}-#{published_at.day}-#{title.parameterize}-#{id}"
    puts self.path
  end
end
