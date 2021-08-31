class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :content, presence: true, length: { maximum: 30 }
  validates :price, presence: true, length: { minimum: 0 }
  validates :user_id, presence: true
  validates :category_id, presence: true

end
