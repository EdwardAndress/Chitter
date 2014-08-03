require 'spec_helper'
require 'post'

describe Post do
	
	context "Datamapper functions" do 

		it 'the DB should be created empty' do
			expect(Post.count).to be (0)
		end

		it 'should store a post after one is created' do 
			Post.create(message: "Hello world")
			expect(Post.count).to be (1)
		end

	end
end