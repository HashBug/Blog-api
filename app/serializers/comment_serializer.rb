class CommentSerializer < ActiveModel::Serializer
  attributes :id,:content,:likes,:dislikes,:user
  belongs_to :post
  belongs_to :user
end
