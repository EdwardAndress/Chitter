require 'spec_helper'

feature 'users' do
	
	scenario 'can sign up' do
		visit '/'
		expect(page).to have_content("Join the Chitterati")
	end

	scenario 'are stored in the DB after signing up' do 
		visit '/'
		click_button "Sign up"
		expect(page).to have_content("Please enter your details")
		lambda { sign_up }.should change(User, :count).by (1)
		expect(page).to have_content("Welcome, Eddie, Chitter away!")
		expect(User.first.email).to eq("eddie_andress@hotmail.com")
	end

	scenario 'can sign in' do
		User.create(:email => "test@test.com", :name => "Tester", :password => "testes", :password_confirmation => "testes")
		expect(User.count).to eq(1)
		visit '/'
		expect(page).to have_content("Sign in")
		sign_in("test@test.com", "testes")
		expect(page).to have_content("Welcome, Tester, Chitter away!")
	end

	scenario 'can sign out' do
		 User.create(:email => "test@test.com", :name => "Tester", :password => "testes", :password_confirmation => "testes")
		 visit '/'
		 sign_in("test@test.com", "testes")
		 click_button "Sign out"
		 expect(page).to have_content("Goodbye!")
	end

	def sign_in(email, password)
		fill_in :email, with: email
		fill_in :password, with: password
		click_button "Sign in"
	end

	def sign_up(email= "eddie_andress@hotmail.com", name= "Eddie", password= "chitterati", password_confirmation= "chitterati")
		fill_in :email, with: email
		fill_in :name, with: name
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation
		click_button "Pledge"
	end
end