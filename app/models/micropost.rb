class Micropost < ActiveRecord::Base
	belongs_to :user
    # user.microposts
    # user.microposts.create(arg)   'replaces'   Micropost.create 
    # user.microposts.create!(arg)  'replaces'   Micropost.create!
    # user.microposts.build         'replaces'   Micropost.new
    
    default_scope -> { order('created_at DESC') }
    validates :content, presence: true, length: { maximum:  140}
    validates :user_id, presence: true
end
