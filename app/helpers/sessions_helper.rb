module SessionsHelper
  def sign_in(user)
    signed_in_token = User.new_signed_in_token
    cookies.permanent[:signed_in_token] = signed_in_token
    user.update_attribute(:signed_in_token, User.encrypt(signed_in_token))
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:signed_in_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    signed_in_token = User.encrypt(cookies[:signed_in_token])
    @current_user ||= User.find_by(signed_in_token: signed_in_token)
  end  
end
