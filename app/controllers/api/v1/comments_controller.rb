class Api::V1::CommentsController < ApplicationController
	before_action :set_comments, except: [:index,:create]

	def index

	end

	def show
		render json: @comments
	end

	def create
		comment = Comment.new(comment_params)
		session = get_session
		comment[:user_id] = session.user_id
		if comment.save
			update_count(comment)
			render json: comment
		else
			render json: {error: comment.errors.full_messages}
		end
	end

	def update

	end

	def destroy

	end

	private
		def comment_params
			params.require(:comment).permit(:content,:user_id,:post_id)
		end

		def set_comments
			@comments = Comment.where(post_id: params[:post_id])
		end

		def update_count comment
			post = Post.find(comment[:post_id])
			count = post[:comments_count]+1
			post.update_attributes(comments_count: count)
		end
end
