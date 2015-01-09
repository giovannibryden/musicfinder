class User < ActiveRecord::Base
	validates :name, presence: true
	validates :genre, presence: true
end
