class User < ActiveRecord::Base
	before_save { self.email.downcase! }
	before_create :create_signed_in_token
	
	validates :name, presence: true, length: { maximum: 50 }
	
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }

	has_secure_password

	validates :password, length: { minimum: 8 }

  def User.new_signed_in_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end


  private

    def create_signed_in_token
      self.signed_in_token = User.encrypt(User.new_signed_in_token)
    end
end
