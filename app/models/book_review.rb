class BookReview < ApplicationRecord
  belongs_to :book
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
