require 'bcrypt'

class User

	include DataMapper::Resource

	property :id, Serial
	property :name, String
	property :email, String, unique: true, message: "That email address is already associated with a member of the Chitterati"
	property :password_digest, Text

	attr_reader :password_digest
	attr_accessor :password_confirmation

	validates_confirmation_of :password, message: "Sorry your passwords do not match"
	validates_confirmation_of :email

	def password=(password)
		@password = password
		self.passwword_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		user = first(email: email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user
		else
			nil
		end
	end
end