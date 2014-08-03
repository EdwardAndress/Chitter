require 'spec_helper'
require 'user'

describe User do
	
	context "the DB should.." do 

		xit 'contain no users when first created' do 
			expect(User.count).to eq(0)
		end

		xit 'store users after they are created' do 
			User.create(name: "Eddie",
						email: "eddie_andress@hotmail.com",
						password: "chitterati",
						password_confirmation: "chitterati")
		end

	end

end