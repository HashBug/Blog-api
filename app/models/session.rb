class Session < ActiveRecord::Base
  belongs_to :user
  before_create :set_auth_token

  validates :user_id, presence: true
  after_commit :clear_cache

  def clear_cache
	Rails.cache.delete([self.class.name,id])
  end

  def self.find_cached(auth_token)
  	Rails.cache.fetch([name,auth_token]){ find_by(auth_token: auth_token) }
  end

  private
		def set_auth_token
			return if auth_token.present?
			self.auth_token = generate_auth_token
		end

		def generate_auth_token
			loop do
				token = SecureRandom.hex
				break token unless self.class.exists?(auth_token: token)
			end
		end
end
