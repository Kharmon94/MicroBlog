class User < ActiveRecord::Base
  has_many :Post
end

class Post < ActiveRecord::Base
  belongs_to :User
end
