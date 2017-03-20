class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string    :username
      t.string    :firstname
      t.string    :lastname
      t.string    :password_digest
      t.string    :email
      t.string    :access_token
      t.string    :fb_uid
      t.string	  :google_uid
      t.string	  :twitter_uid
      t.string	  :li_uid
      t.string    :image
      t.string    :dob
      t.string    :gender
      t.string    :country
      t.string    :gplus_link
      t.string    :fb_link
      t.string    :twitter_link
      t.string	  :li_link
      t.string    :website
      t.string    :verification_code
      t.string	  :refer_code
      t.string    :timezone
      t.string	  :login_ip
      t.text      :about
      t.text      :tagline
      t.datetime  :last_login
      t.integer   :login_count, :default => 0
      t.integer   :points
      t.integer   :email_verified, :limit => 1, :default => 0
      t.integer   :referred, :limit => 1, :default => 0
      t.integer   :role, :limit => 1, :default => 1
      t.integer   :status, :limit => 1, :default => 0

      t.timestamps null: false
    end
  end
end
