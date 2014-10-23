class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  after_filter :store_location

  protected

  def configure_devise_permitted_parameters
    registration_params = [:nome, :email, :password, :password_confirmation, :photo, :sexo, :datanasc]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params, :remove_photo)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (!request.fullpath.match("/users") && 
      !request.xhr?) # don't store ajax calls
      if request.format == "text/html" || request.content_type == "text/html"
        session[:previous_url] = request.fullpath
        session[:last_request_time] = Time.now.utc.to_i
      end
    end
  end
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(AdminUser)
        admin_dashboard_path
      else
        session[:previous_url] || root_path
      end
  end

end
