class Api::V1::SessionsController < ApplicationController
	before_action :set_session, except: [:create, :index]

	def index	#get the session if logged in
		session = get_session
		render json: {session: session}
	end

	def show
		##For Future Use##
	end

	def update
		#yet to be implemented
		#will be required when either (auth or gcm) of the tokens expire
	end

	def destroy		#logout user by destroyng session
		@session.destroy
		render json: {session: @session}, status: 200
	end

	def create_session   #login user
		username = params[:username]
		email = params[:email]
		gcm_key = params[:gcm_key]
		password = params[:password]

		#check if user is valid
		user = legit_user(username,email,password)

		if user && user.status == 1
			create_session(user,gcm_key)
		elsif user && user.status == 0    #status 0 denoted unverified email
			render json: {error: "Email not verified"}, status: 403
		else
			render json: {error: "Wrong Credentials"}, status: 403
		end
	end

	def legit_user(username,email,password)
		if !username.blank?
			user = User.find_by(username: username)
			is_authenticated(user,password)
		elsif !email.blank?
			user = User.find_by(email: email)
			is_authenticated(user,password)
		else
			return false
		end
	end

	def is_authenticated(user,password)
		if user.authenticate(password) #authenticate using bcrypt 
			return user
		else
			return false
		end
	end

	def create_session(user,gcm_key)
		session = Session.new
		session[:user_id] = user.id
		session[:expires_at] = 2.weeks.from_now 
		session[:gcm_token] = gcm_key
		if session.save
			render_token(session)
		else
			render json: {error: "An error occurred"}, status: 500
		end
	end

	private

		def set_session
			@session = Session.find(params[:id])
		end

		def session_params
			params.permit(:username,:email,:password,:gcm_key)
		end

		##WARNING: move this to model/application if used anywhere else##
		def render_token(session)
			#return token after session created successfully
			auth_token = session.auth_token
			user_id = session.user_id
			secret = 'pass@123'
			payload = {auth_token: auth_token, user_id: user_id}
			token = JWT.encode payload,secret
			render json: {token: token}, status: 200
		end
end
