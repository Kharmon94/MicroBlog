class User < ActiveRecord::Base
	validates_uniqueness_of :username
  has_many :Post
end

class Post < ActiveRecord::Base
  belongs_to :User
end
