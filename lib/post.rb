class Post

	include DataMapper::Resource

	property :id, Serial
	property :message, Text

	has n, :tags, through: Resource

end