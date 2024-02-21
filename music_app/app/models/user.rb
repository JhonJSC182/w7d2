# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: { minimum: 6, allow_nil: true}
    validates :session_token, uniqueness: true

    before_validation :ensure_session_token
    attr_reader :password

    def self.find_by_credentials(email, password)
        email = User.find_by(email: email)
        if email && email.is_password?(password)
            email
        else
            nil
        end
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        db_pass = BCrypt::Password.new(password_digest)
        db_pass.is_password?(password)
    end

    def reset_session_token
        self.session_token = generate_session_token
        self.save!
        self.session_token
    end

    private

    def ensure_session_token
        self.session_token ||= generate_session_token
    end

    def generate_session_token
        loop do
            token = SecureRandom::urlsafe_base64(16) 
            return token unless User.exists?(session_token: token)
        end
    end
end
