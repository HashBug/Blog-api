class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

      t.text :content
      t.integer :type
      t.integer :parent
      t.integer :likes, default: 0
      t.integer :dislikes, default: 0	
      t.integer :status, limit:1, default: 1
      t.references :user, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
