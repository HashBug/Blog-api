class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|

      t.string :title
      t.string :url
      t.text :content
      t.integer :status, limit: 1, default: 1
      t.integer :likes_count, default: 0
      t.integer :dislikes_count, default: 0
      t.integer :comments_count, default: 0
      t.integer :top, limit: 1, default: 0
      t.integer :flag, default: 0
      t.integer :liked, default: 0, limit: 1	
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
