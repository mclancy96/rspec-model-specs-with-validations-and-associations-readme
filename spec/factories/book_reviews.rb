FactoryBot.define do
  factory :book_review do
    content { "Great read!" }
    rating { 5 }
    association :book
  end
end
