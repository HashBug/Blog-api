class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|

    	t.string :name
    	t.string :slug
    	t.integer :type
    	t.integer :parent
    	t.integer :status, limit: 1 ,default: 1
      t.timestamps null: false
    end
  end
end
