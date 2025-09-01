class CreateBookReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :book_reviews do |t|
      t.text :content
      t.integer :rating
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
