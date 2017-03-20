class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|

      t.string	:auth_token
  	  t.string	:gcm_token
  	  t.string	:login_ip
  	  t.integer :status, default: 1
  	  t.datetime :expires_at	
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
