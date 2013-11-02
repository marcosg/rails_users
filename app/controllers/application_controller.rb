class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale


	private

	def set_locale
	  #I18n.locale = params[:locale] if params[:locale].present?
	  # current_user.locale
	  # request.subdomain
	  # request.env["HTTP_ACCEPT_LANGUAGE"]
	  # request.remote_ip

	  if params[:locale].present?
	  	I18n.locale = params[:locale]
	  else
	  	I18n.locale = "#{I18n.default_locale}"
		  language = request.env['HTTP_ACCEPT_LANGUAGE']    
		  if language
		    language = language.scan(/^[a-z]{2}/).first
		    if language.match /^(#{I18n.available_locales.join("|")})$/
		      I18n.locale = language
		  	end
		  end
		end
	end

	def default_url_options(options = {})
	  {locale: I18n.locale}
	end

end

