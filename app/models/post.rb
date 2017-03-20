class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :comments

  validates :title, presence: true
  validates :url, presence: true, uniqueness: true
  validates :content, presence: true
  validates :user_id, presence: true

  after_commit :clear_cache

	def clear_cache
		Rails.cache.delete([self.class.name,id])
		Rails.cache.delete([self.class.name,"all"])
	end

	def self.cached_find(id)
		Rails.cache.fetch([name,id]) {includes(:comments => :user).find(id)}
	end

	def self.show_all_cached
	Rails.cache.fetch([name,"all"]) { all.includes(:comments => :user).to_a}
	end

end
