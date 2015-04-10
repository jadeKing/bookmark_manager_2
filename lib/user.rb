require 'bcrypt'

# SHhhhhhhhhh!
class User
  include DataMapper::Resource
  attr_reader :password
  attr_accessor :password_confirmation

  validates_uniqueness_of :email,
                          message: 'Sorry, your email address is already taken'
  validates_confirmation_of :password,
                            message: 'Sorry, your passwords do not match :Þ'

  property :id, Serial
  property :email, String,
           unique: true,
           message: 'Sorry, your email address is already taken :Þ'
  property :password_digest, Text

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
      # else
      #   nil
    end
  end
end
