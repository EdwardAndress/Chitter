require 'spec_helper'

feature "A user can browse posts" do 

	before(:each) {
		Post.create(message: "Hello world")
	}

	scenario "on the homepage" do 
		visit '/'
		expect(page).to have_content("Hello world")
	end 

end