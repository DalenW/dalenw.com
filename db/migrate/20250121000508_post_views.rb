class PostViews < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :views_count, :integer, default: 0, limit: 8
  end
end
