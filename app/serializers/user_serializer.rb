class UserSerializer < ActiveModel::Serializer
  attributes :id,:firstname,:lastname,:username,:image,:email,:dob,:gender,:country,:refer_code,:tagline,:about,:login_count,:points,:gplus_link,:li_link,:fb_link,:twitter_link
  has_many :posts
  has_many :comments
end
