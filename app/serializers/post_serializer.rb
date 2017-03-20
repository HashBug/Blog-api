class PostSerializer < ActiveModel::Serializer
  attributes :id,:title,:url,:content,:comments_count,:likes_count,:dislikes_count,:liked,:top,:created_at,:updated_at
  has_many :comments
  belongs_to :user
end
