require 'rails_helper'

describe Book, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:book)).to be_valid
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:author) }
  it { should have_many(:book_reviews).dependent(:destroy) }

  it 'can have many reviews' do
    book = create(:book)
    review1 = create(:book_review, book: book)
    review2 = create(:book_review, book: book)
    expect(book.book_reviews).to include(review1, review2)
  end

  it 'destroys associated reviews when destroyed' do
    book = create(:book)
    create(:book_review, book: book)
    expect { book.destroy }.to change { BookReview.count }.by(-1)
  end

  it 'has a pending spec for students: validates uniqueness of title' do
    pending('Add a uniqueness validation for title and test it')
    raise 'Not implemented'
  end
end
