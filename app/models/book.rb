class Book < ApplicationRecord
	has_many :book_reviews, dependent: :destroy
	validates :title, presence: true
	validates :author, presence: true
end
