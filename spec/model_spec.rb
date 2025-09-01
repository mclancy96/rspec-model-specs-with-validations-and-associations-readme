
require_relative '../app/models/book'
require_relative '../app/models/book_review'

RSpec.describe BookReview do

  it 'is valid with content and rating between 1 and 5' do
    review = BookReview.new(content: 'Great book!', rating: 5, book: Book.new(title: 'Sample', author: 'Author'))
    expect(review.valid?).to eq(true)
    expect(review.errors).to be_empty
  end

  it 'is invalid without content' do
    review = BookReview.new(content: '', rating: 4)
    expect(review.valid?).to eq(false)
    expect(review.errors[:content]).to include("can't be blank")
  end

  it 'is invalid with rating out of range' do
    review = BookReview.new(content: 'Nice try', rating: 6)
    expect(review.valid?).to eq(false)
    expect(review.errors[:rating]).to include("is not included in the list")
  end

  it 'can belong to a book' do
    book = Book.new(title: '1984', author: 'George Orwell')
    review = BookReview.new(content: 'Classic!', rating: 5, book: book)
    expect(review.book).to eq(book)
  end

  it 'can be associated with multiple reviews for a book' do
    book = Book.new(title: 'Dune', author: 'Frank Herbert')
    review1 = BookReview.new(content: 'Epic!', rating: 5, book: book)
    review2 = BookReview.new(content: 'Loved it', rating: 4, book: book)
    expect([review1, review2].map(&:book)).to all(eq(book))
  end

  it 'returns errors for both missing content and invalid rating' do
    review = BookReview.new(content: '', rating: 0)
    expect(review.valid?).to eq(false)
    expect(review.errors[:content]).to include("can't be blank")
    expect(review.errors[:rating]).to include("is not included in the list")
  end

  it 'can update content and rating' do
    review = BookReview.new(content: 'Good', rating: 3)
    review.content = 'Excellent!'
    review.rating = 5
    expect(review.content).to eq('Excellent!')
    expect(review.rating).to eq(5)
  end

  it 'has a pending spec for students: validates that a review cannot be added to two books' do
    pending('Implement logic to prevent a review from being added to two books')
    raise 'Not implemented'
    # book1 = Book.new('Book 1', 'Author A')
    # book2 = Book.new('Book 2', 'Author B')
    # review = BookReview.new('Interesting', 4)
    # book1.add_review(review)
    # book2.add_review(review)
    # expect(review.book).to eq(book1) # or some error/validation
  end

  it 'has a pending spec for students: validates that a review must have a book before saving' do
    pending('Implement logic to require a book before saving a review')
    raise 'Not implemented'
    # review = BookReview.new('Missing book', 3)
    # expect(review.save).to eq(false)
    # expect(review.errors).to include('Book must be present')
  end
end
