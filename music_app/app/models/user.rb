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
        password_digest = Bcrypt::Password.create(password)
    end

    def is_password?(password)
        db_pass = Bcrypt::Password.new(password_digest)
        db_pass.is_password?(password)
    end
end
