class Article < ActiveRecord::Base
	has_many :comments, dependent: :destroy
	validates :title, presence: true,
                    length: { minimum: 10 }
    validates :body, presence: true
    validates :author, presence: true,
                    length: { minimum: 5 }
end
