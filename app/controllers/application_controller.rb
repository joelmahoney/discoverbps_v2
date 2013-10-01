class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_student
  # after_filter :store_location

  private
  
  def current_student
  	if session[:current_student_id].present?
	  	Student.find(session[:current_student_id]) rescue nil
	  end
  end

	# def store_location
	#  # store last url - this is needed for post-login redirect to whatever the user last visited.
	#     if (request.fullpath != "/users/sign_in" && \
	#         request.fullpath != "/users/sign_up" && \
	#         request.fullpath != "/users/password" && \
	#         !request.xhr?) # don't store ajax calls
	#       session[:previous_url] = request.fullpath 
	#     end
	# end

	def after_sign_out_path_for(resource_or_scope)
	  root_url
	end

	def after_sign_up_path_for(resource)
	  root_path
	end

	def after_sign_in_path_for(resource)
	  schools_url
	end
end
