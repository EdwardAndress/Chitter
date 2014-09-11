require 'spec_helper'

feature "Users can make posts" do

	scenario "when logged in" do
		User.create(:email => "test@test.com", :name => "Tester", :password => "testes", :password_confirmation => "testes")
		sign_in(email: "test@test.com", password: "testes")
		expect(Post.count).to eq(0)
		visit '/:user/posts'
		add_post(message: "Are you there?")
		expect(Post.count).to eq(1)
		post = Post.first
		expect(post.message).to eq("Are you there?")
	end

	scenario "and associate tags" do 
		visit '/:user/posts'
		add_post(message: 'this is a new post', tags: ["test", "test2"])
		post = Post.first
		expect(post.tags.map(&:text)).to include("test")
		expect(post.tags.map(&:text)).to include("test2")
	end

	scenario 'then filter posts by tag' do 
		visit '/:user/posts'
		add_post(message: 'this is the correct post', tags: ["correct"])
		add_post(message: 'this is the incorrect post', tags: ["incorrect"])
		fill_in 'filter', with: "correct"
		click_button 'Filter'
		expect(page).to have_content("this is the correct post")
		expect(page).not_to have_content("this is the incorrect post")
	end

	def add_post(message: message, tags: [])
		within('#new-post') do 
			fill_in 'message', with: message
			fill_in 'tags', with: tags.join(' ')
			click_button 'Submit'
		end
	end
end