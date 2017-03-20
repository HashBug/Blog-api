class ApplicationController < ActionController::API
	include ActionController::MimeResponds
	include ActionController::HttpAuthentication::Token::ControllerMethods
	include ActionController::Serialization
	include MyModules::ErrorSerializer

	require 'gcm'
	require 'jwt'

	def authenticate_token
		secret = 'pass@123' #choose better secret in production
		authenticate_with_http_token do |token,options|
			decoded_token = JWT.decode token, secret #returns an array
			#fetch auth_token from the array
			auth_token = decoded_token[0]['auth_token']
			#look for session in db with obtained token
			session = Session.find_cached(auth_token)
			@user_id = session.user_id if session
		end
		@user_id ? @user_id : false
	end

	def set_current_user
		current_user_id = authenticate_token
		current_user_id ? @current_user = User.cached_find(current_user_id) : render_unauthorized
	end

	def is_admin
		@current_user.role == 5 ? true : false
	end

	def check_admin
		admin = is_admin ? true : render_unauthorized
	end

	def get_session
		token = request.headers['Authorization']
		if token
			@token = token.split(' ')
			data = JWT.decode @token[1],'pass@123'
			auth_token = data[0]['auth_token']
			session = Session.find_by(auth_token: auth_token)
		else
			session = false
		end
		return session
	end

	def render_unauthorized
		self.headers['WWW-Authenticate'] = 'Token realm = "Application"'
		render json: 'Bad Credentials', status: 401			
	end
end
