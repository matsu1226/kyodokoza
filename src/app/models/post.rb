class Post < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :category, foreign_key: "category_id"

  validates :content, presence: true, length: { maximum: 30 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :purchased_at, presence: true


  scope :month, -> (month) { where(purchased_at: month.all_month) }
  scope :sorted, -> { order(purchased_at: :asc) }


end
