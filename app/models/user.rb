class User < ActiveRecord::Base
	has_secure_password
	has_many :sessions
	has_many :posts
	has_many :comments
	before_create :set_access_token

	validates :firstname, presence: true, length: {maximum: 25}
	validates :lastname, presence: true, length: {maximum: 25}
	validates :username, presence: true, length: {maximum: 25}, uniqueness: true
	before_save { email.downcase! }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email,presence: true, length: {maximum: 150},format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
	validates :password, presence: true, length: {minimum: 6}, on: :save

	after_save :generate_codes
	after_commit :clear_cache

	def clear_cache
		Rails.cache.delete([self.class.name,id])
		Rails.cache.delete([self.class.name,"all"])
	end

	def self.cached_find(id)
		Rails.cache.fetch([name,id]){ find(id) }
	end

	def self.show_all_cached
		Rails.cache.fetch([name,"all"]) { all.to_a }
	end

	#generate verification and referal code after registration
	def generate_codes
		return if verification_code.present? || refer_code.present?
		verification_code = "#{self.id}#"+"#{SecureRandom.hex(3)}"
		refer_code = "#{self.id}#"+"#{SecureRandom.hex(3)}"
		self.update_attributes(verification_code: verification_code,refer_code: refer_code)
	end

	private
		def set_access_token
			return if access_token.present?
			self.access_token = generate_access_token
		end

		def generate_access_token
			loop do
				token = SecureRandom.hex
				break token unless self.class.exists?(access_token: token)
			end
		end
end
