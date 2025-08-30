# RSpec: Model Specs with Validations & Associations

Welcome to Lesson 20! In this lesson, we're going to take a deep dive into writing RSpec model specs for ActiveRecord validations and associations in Rails. We'll also introduce FactoryBot, your new best friend for setting up test data. If you know Ruby and Rails but are new to automated testing, this is your on-ramp to writing robust, maintainable, and DRY model specs. We'll explain every concept in multiple ways, show you lots of code examples (with file path comments!), and give you practice prompts to reinforce your learning. Let's get started!

---

## Why Test Models?

Models are the heart and soul of your Rails app. They:

- Hold your business logic
- Enforce validations (rules about what data is allowed)
- Define associations (how models relate to each other)

If your models are wrong, your whole app can break! Testing models ensures:

- Your data stays clean (no missing usernames, no orphaned records)
- Your app behaves as expected
- You catch bugs before they reach production

**Think of model specs as your app's immune system.**

---

## Setting Up: FactoryBot (Test Data, the Easy Way)

Writing tests is a lot easier when you can quickly create test data. That's where FactoryBot comes in! Instead of writing out every attribute by hand, you define a factory once and use it everywhere.

### Step 1: Add FactoryBot to Your Gemfile

```ruby
# /Gemfile
gem 'factory_bot_rails'
```

### Step 2: Install the Gem

```zsh
# Terminal
bundle install
```

### Step 3: Configure RSpec to Use FactoryBot

```ruby
# /spec/rails_helper.rb
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

Now you can use `build(:user)` and `create(:user)` in your specs without prefixing with `FactoryBot.` every time.

---

## Writing Specs for Validations

Validations are rules you set on your models to make sure your data is correct. For example, you might require every user to have a username and email, and that usernames are unique.

### Example User Model with Validations

```ruby
# /app/models/user.rb
class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true
end
```

### How to Test Validations

You want to check:

- The model is valid when all required attributes are present
- The model is invalid when required attributes are missing
- The model is invalid when uniqueness is violated

#### Example Spec for Validations

```ruby
# /spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without a username" do
    user = build(:user, username: nil)
    expect(user).not_to be_valid
    expect(user.errors[:username]).to include("can't be blank")
  end

  it "is invalid without an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid with a duplicate username (case-sensitive)" do
    create(:user, username: "bob")
    user = build(:user, username: "bob")
    expect(user).not_to be_valid
    expect(user.errors[:username]).to include("has already been taken")
    # Output example:
    # puts user.errors.full_messages
    # => ["Username has already been taken"]
  end

  it "is invalid with a duplicate username (case-insensitive)" do
    create(:user, username: "bob")
    user = build(:user, username: "BOB")
    # If your model uses: validates :username, uniqueness: { case_sensitive: false }
    expect(user).not_to be_valid
    expect(user.errors[:username]).to include("has already been taken")
  end
end
```

**What happens?**

- The first test passes if the factory creates a valid user.
- The next tests check that missing or duplicate data triggers validation errors.

**Example Output:**

```zsh
User
  is valid with valid attributes
  is invalid without a username
  is invalid without an email
  is invalid with a duplicate username

Finished in 0.0123 seconds (files took 0.12345 seconds to load)
4 examples, 0 failures
```

---

## Writing Specs for Associations

Associations define how your models relate to each other. For example, a user might have many posts, or a post might belong to a user.

### Example User Model with Association

```ruby
# /app/models/user.rb
class User < ApplicationRecord
  has_many :posts
end
```

### How to Test Associations

You want to check:

- The association exists (e.g., `has_many :posts`)
- The association works as expected (e.g., adding/removing related records)

#### Example Spec for Association (Manual and Shoulda-Matchers)

```ruby
# /spec/models/user_spec.rb
RSpec.describe User, type: :model do
  # Manual check
  it "has many posts (manual)" do
    assoc = described_class.reflect_on_association(:posts)
    expect(assoc.macro).to eq :has_many
  end

  # Shoulda-Matchers (if installed)
  it { should have_many(:posts) }
end
```

#### Example: Testing the Relationship in Action

```ruby
# /spec/models/user_spec.rb
it "can have many posts" do
  user = create(:user)
  post1 = create(:post, user: user)
  post2 = create(:post, user: user)
  expect(user.posts).to include(post1, post2)
end
```

---

## Using FactoryBot

Factories are blueprints for creating test data. Instead of writing out every attribute, you define a factory once and use it everywhere.

### Example User Factory

```ruby
# /spec/factories/users.rb
FactoryBot.define do
  factory :user do
    username { "testuser" }
    email { "test@example.com" }
  end
end
```

### Example Post Factory

```ruby
# /spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    title { "A blog post" }
    content { "Lorem ipsum..." }
    association :user # This automatically creates and associates a user for each post
  end
end
```

**Tip:** When you use `association :user` in a factory, FactoryBot automatically builds or creates a user and sets up the relationship for you. That's why `create(:post)` gives you a post with a valid user.

**Isolation Reminder:**

- `build(:user)` and `build(:post)` create objects in memory (do not hit the database).
- `create(:user)` and `create(:post)` save objects to the database (slower, but needed for most association tests).

---

## Practice Prompts & Reflection Questions

Try these exercises to reinforce your learning:

1. Write a spec to test a model validation for presence of a field. What happens if you remove the validation from the model?
2. Write a spec to test a uniqueness validation. How would you test for case-insensitive uniqueness?
3. Write a spec to test a `belongs_to` or `has_many` association. How would you test a `has_one` or `has_and_belongs_to_many`?
4. Create a factory for a model and use it in your specs. How does FactoryBot help keep your tests DRY?
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
