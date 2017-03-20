class Api::V1::UsersController < ApplicationController
	before_action :set_user, except: [:create,:index]
	before_action :set_current_user, except: [:create]
	before_action :authorize_user, only: [:show, :update]
	before_action :check_admin, only: [:index,:destroy]

	def index
		@users = User.show_all_cached
		render json: @users
	end

	def create
		user = User.new(user_params)
		#different ways to create a user
		#user can register with fb, gPlus, twitter, linkedIn or email
		if user[:fb_uid]
			fb_login(user)
		elsif user[:google_uid]
			google_login(user)
		elsif user[:twitter_uid]
			twitter_login(user)
		elsif user[:li_uid]
			li_login(user)
		else
			register(user)
		end
	end

	def show
		render json: @user, status: 200
	end

	def update
		if is_admin
			@user.update_attributes(update_admin_params)
		else
			@user.update_attributes(update_params)
		end
		render json: @user, status: 200
	end

	def destroy
		@user.update_attributes(status: 0)
		render json: {message: 'user successfully destroyed'}
	end

	private
		def set_user
			@user = User.cached_find(params[:id])
			rescue ActiveRecord::RecordNotFound => e
	    	return render json: { error: 'user not found' }, status: 404
		end

		def authorize_user
			if is_admin || permitted_user
				return true
			else
				render_unauthorized
			end
		end

		def permitted_user
			@user.id == @current_user.id ? true : false
		end

		def fb_login(user)
			user = fetch_fb_profile(user[:fb_uid])
			if !exist_user(user)
				user[:password] = user['id']
				user[:fb_uid]	= user['id']
				user[:username]	= user['id']
				register(user)
			else
				merge(user)
			end
		end

		def fetch_fb_profile(access_token)
			uri = URI('https://graph.facebook.com/me/')
			params = { :access_token => access_token , :fields => 'email,name,first_name,last_name' }
			uri.query = URI.encode_www_form(params)
			response = Net::HTTP.get_response(uri)
			result = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
			return result if result
		end

		def merge(user)
			
		end

		def google_login(user)

		end

		def twitter_login(user)

		end

		def li_login(user)

		end

		def register(user)
			user[:username] ||= generate_username
			user.password ||= generate_password
			if user.save
				#send mail to registered email ID for verification
				send_mail(user)
				render json: user,status: 201
			else
				render json: MyModules::ErrorSerializer.serialize(user.errors),status: 422
				# adapter: :json_api,serializer: ActiveModel::Serializer::ErrorSerializer
			end
		end

		def send_mail(user)
			email = user.email
			password = user.password
			ActionMailer::Base.mail(from: 'youremail@gmail.com',:to => email, :subject => "Email Confirmation", :body => "You have successfully registered on myblog.com, To login please enter your email address and password. Your password is #{password}").deliver_now
		end

		def return_value(is_user)
			if is_user
				return true
			else
				return false
			end
		end

		def generate_username
			username = SecureRandom.hex(8)
			return username
		end

		def generate_password
			password = '123456' #SecureRandom.hex(6)
			return password
		end

		#params allowed while creation
		def user_params
			params.require(:user).permit(:username,:email,:password,:firstname,:lastname,:fb_uid,:google_uid,:twitter_uid,:li_uid)
		end

		#params allowed while updation
		def update_params
			params.require(:user).permit(:username,:email,:firstname,:lastname,:password)
		end

		def update_admin_params
			params.require(:user).permit!
		end

end
