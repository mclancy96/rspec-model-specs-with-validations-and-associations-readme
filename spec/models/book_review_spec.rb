require 'rails_helper'

describe BookReview, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:book_review)).to be_valid
  end

  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:rating) }
  it { should validate_inclusion_of(:rating).in_range(1..5) }
  it { should belong_to(:book) }

  it 'is invalid without content' do
    review = build(:book_review, content: nil)
    expect(review).not_to be_valid
    expect(review.errors[:content]).to include("can't be blank")
  end

  it 'is invalid with rating out of range' do
    review = build(:book_review, rating: 10)
    expect(review).not_to be_valid
    expect(review.errors[:rating]).to include("is not included in the list")
  end

  it 'has a pending spec for students: validates that a review cannot be added without a book' do
    pending('Add validation to require a book for each review and test it')
    raise 'Not implemented'
  end
end
