class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.timestamps

      t.string :title
      t.string :description
      t.string :path

      t.timestamptz :publish_at, null: false, index: true

      t.integer :status, default: 0, null: false, index: true, limit: 1

      t.references :user, index: true, foreign_key: true
    end
  end
end
