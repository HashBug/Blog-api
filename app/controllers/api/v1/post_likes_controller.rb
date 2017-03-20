class Api::V1::PostLikesController < ApplicationController

	def create
		like = PostLike.new(like_params)
		session = get_session
		like[:user_id] = session.user_id if session 
		if like[:user_id] && like_is_unique(like)
			save_like like
		else
			render json: {error: 'you are not authorized to do this'}, status: 422
		end
	end

	def save_like like
		if like.save
			update_post(like[:post_id])
			render json: like
		else
			render json: like, status: 422,adapter: :json_api,serializer: ActiveModel::Serializer::ErrorSerializer
		end
	end

	def show

	end

	def update

	end

	def destroy

	end

	private
		def like_params
			params.require(:postLike).permit(:user_id,:post_id,:like)
		end

		def like_is_unique like
			postlike = PostLike.where(post_id: like[:post_id]).where(user_id: like[:user_id])
			if postlike.length > 0
				return false
			else
				return true
			end
		end

		def update_post post_id
			post = Post.find(post_id)
			count = post[:likes_count] + 1
			post.update_attributes(likes_count: count)
		end
end
