
# RSpec: Model Specs with Validations & Associations (Book & BookReview Edition)

In this lesson, you'll learn how to write robust model specs for validations and associations using a real Rails/ActiveRecord setup with a Book/BookReview domain. All examples use Rails models, migrations, and RSpec best practices, so you can focus on realistic, hands-on learning. You'll see how to test validations, associations, and more, with clear, practical examples.

---

## Why Test Models?

Models are the heart and soul of your app. They:

- Hold your business logic
- Enforce validations (rules about what data is allowed)
- Define associations (how models relate to each other)

If your models are wrong, your whole app can break! Testing models ensures:

- Your data stays clean (no missing reviews, no orphaned books)
- Your app behaves as expected
- You catch bugs before they reach production

**Think of model specs as your app's immune system.**

---

## Getting Hands-On

> **Note:** This lesson uses [FactoryBot](https://github.com/thoughtbot/factory_bot) to help you quickly create test data in your specs. You will learn about FactoryBot in detail in Lesson 23. For now, you can use the provided factories as shown in the examples below—no need to understand all the details yet!

Ready to practice? Here’s how to get started:

1. **Fork and clone this repo to your own GitHub account.**
2. **Install dependencies:**

    ```zsh
    bundle install
    ```

3. **Set up the database:**

    ```zsh
    bin/rails db:migrate
    ```

4. **Run the specs:**

    ```zsh
    bin/rspec
    ```

5. **Explore the code:**

   - All lesson code uses the Book and BookReview domain (see `app/models/`, `db/migrate/`, `spec/models/`, and `spec/factories/`).
   - Review the examples for validations and associations.

6. **Implement the pending specs:**

   - Open `spec/models/book_spec.rb`, `spec/models/book_review_spec.rb`, and `spec/model_spec.rb` and look for specs marked as `pending`.
   - Implement the real methods in the Rails models (`app/models/book.rb`, `app/models/book_review.rb`) as needed so the pending specs pass.

7. **Re-run the specs** to verify your changes!

**Challenge:** Try writing your own spec for a new validation or association on Book or BookReview, or add a new model and test it.

---

## Writing Specs for Validations

Validations are rules you set on your models to make sure your data is correct. For example, you might require every book review to have content and a rating between 1 and 5.

### Example BookReview Model with Validations (Rails)

```ruby
# app/models/book_review.rb
class BookReview < ApplicationRecord
  belongs_to :book
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
```

### How to Test Validations (with Shoulda Matchers)

You want to check:

- The model is valid when all required attributes are present
- The model is invalid when required attributes are missing
- The model is invalid when the rating is out of range

#### Example Spec for Validations

```ruby
# spec/models/book_review_spec.rb
require 'rails_helper'

RSpec.describe BookReview, type: :model do
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:rating) }
  it { should validate_inclusion_of(:rating).in_range(1..5) }

  it "is valid with valid attributes" do
    review = FactoryBot.build(:book_review)
    expect(review).to be_valid
  end

  it "is invalid without content" do
    review = FactoryBot.build(:book_review, content: nil)
    expect(review).not_to be_valid
    expect(review.errors[:content]).to include("can't be blank")
  end

  it "is invalid with rating out of range" do
    review = FactoryBot.build(:book_review, rating: 6)
    expect(review).not_to be_valid
    expect(review.errors[:rating]).to include("is not included in the list")
  end
end
```

---

## Writing Specs for Associations

Associations define how your models relate to each other. For example, a book might have many reviews, and a review belongs to a book.

### Example Book and BookReview Models with Associations (Rails)

```ruby
# app/models/book.rb
class Book < ApplicationRecord
  has_many :book_reviews, dependent: :destroy
  validates :title, presence: true
  validates :author, presence: true
end

# app/models/book_review.rb
class BookReview < ApplicationRecord
  belongs_to :book
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
```

### How to Test Associations (with Shoulda Matchers)

You want to check:

- The association exists (e.g., a book has many reviews)
- The association works as expected (e.g., adding/removing related reviews)

#### Example Spec for Associations

```ruby
# spec/models/book_spec.rb
require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should have_many(:book_reviews).dependent(:destroy) }

  it "can have many reviews" do
    book = FactoryBot.create(:book)
    review1 = FactoryBot.create(:book_review, book: book)
    review2 = FactoryBot.create(:book_review, book: book)
    expect(book.book_reviews).to contain_exactly(review1, review2)
    expect(review1.book).to eq(book)
    expect(review2.book).to eq(book)
  end
end
```

---

## Using FactoryBot for Test Data

In this Rails lesson, we use FactoryBot to create test data for our specs. Factories are defined in `spec/factories/`:

```ruby
# spec/factories/books.rb
FactoryBot.define do
  factory :book do
    title { "Sample Book" }
    author { "Sample Author" }
  end
end

# spec/factories/book_reviews.rb
FactoryBot.define do
  factory :book_review do
    content { "Great book!" }
    rating { 5 }
    association :book
  end
end
```

> **Reminder:** If you haven't seen FactoryBot before, don't worry! It's a tool for creating test data, and it's already set up for you in this lesson. You'll get a full introduction in Lesson 23.

Use these factories in your specs to keep your tests DRY and focused:

```ruby
let(:book) { FactoryBot.create(:book) }
let(:review) { FactoryBot.create(:book_review, book: book) }
```

---

## Practice Prompts & Reflection Questions

Try these exercises to reinforce your learning:

1. Write a spec to test a model validation for presence of content or rating. What happens if you remove the validation from the model?
2. Write a spec to test that a review cannot be added to two books. How would you enforce this rule in Rails?
3. Write a spec to test a `has_many` or `belongs_to` association. How would you test a `has_one` or a more complex relationship?
4. Create a factory for building reviews or books and use it in your specs. How does this help keep your tests DRY?
5. Why is it important to test both validations and associations in your models?

Reflect: What could go wrong in your app if you didn't test your models?

---

## Resources

- [RSpec: Model Specs](https://relishapp.com/rspec/rspec-rails/v/5-0/docs/model-specs/model-spec)
- [Rails Guides: Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html)
- [Rails Guides: Active Record Associations](https://guides.rubyonrails.org/association_basics.html)
- [FactoryBot Documentation](https://github.com/thoughtbot/factory_bot)
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers)
- [Better Specs: Models](https://www.betterspecs.org/#models)
