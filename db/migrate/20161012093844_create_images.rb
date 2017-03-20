class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|

      t.string :url	
      t.string :title
      t.string :detail
      t.string :status, limit: 1, default: 1
      t.references :user, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
