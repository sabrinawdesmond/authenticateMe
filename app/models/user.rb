class User < ApplicationRecord
  has_secure_password
  validates :username, length: { in: 3..30 }, uniqueness: true, format: { without: URI::MailTo::EMAIL_REGEXP, message: "can't be an email" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, length: { in: 6..255 }, allow_nil: true
  validates :session_token, presence: true, uniqueness: true

  before_validation :ensure_session_token

  def self.find_by_credentials(credential, password)
    if credential.match(URI::MailTo::EMAIL_REGEXP)
      user = User.find_by(email: credential)
    else
      user = User.find_by(username: credential)
    end

    if user && user.authenticate(password)
      return user
    else
      return nil 
    end
  end

  def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
  end

  private

  def generate_unique_session_token
    token = SecureRandom::urlsafe_base64
      while User.exists?(session_token: token)
        token = SecureRandom::urlsafe_base64
      end
      token
  end

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end
end
