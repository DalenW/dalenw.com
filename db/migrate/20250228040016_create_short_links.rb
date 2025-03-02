class CreateShortLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :short_links do |t|
      t.timestamps

      t.text :url, null: false
      t.text :code, null: false, index: { unique: true }
      t.integer :clicks, null: false, default: 0
      t.boolean :enabled, null: false, default: true
      t.references :linkable, polymorphic: true, index: true, null: true
      t.references :user, null: false, foreign_key: true
    end
  end
end
