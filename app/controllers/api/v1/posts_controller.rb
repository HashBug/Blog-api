class Api::V1::PostsController < ApplicationController

	before_action :set_post, except: [:create,:index]

	def index
		posts = Post.show_all_cached
		session = get_session
		likes = PostLike.where(user_id: session.user_id).pluck(:post_id)
		posts.each do |post|
			if likes.include? post.id
				post[:liked] = 1
			end
		end
		render json: posts
	end

	def show
		post_liked(@post) ? @post[:liked] = 1 : @post[:liked] = 0
		render json: @post
	end

	def create
		post = Post.new(post_params)
		session = get_session
		post[:user_id] = session.user_id if session
		if post.save
			render json: post
		else
			render json: post, status: 422,adapter: :json_api,serializer: ActiveModel::Serializer::ErrorSerializer
		end
	end

	def update

	end

	def destroy

	end

	private
		def set_post
			@post = Post.cached_find(params[:id])
		end

		def post_params
			params.require(:post).permit(:title,:content,:url,:user_id,:category_id)
		end

		def post_liked post
			session = get_session
			if session
				liked = PostLike.where(post_id: post.id).where(user_id: session.user_id)
				liked.size > 0 ? true : false
			else
				return false
			end
		end
end
