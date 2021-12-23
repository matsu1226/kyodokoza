class FixedCost < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :content, presence: true, length: { maximum: 30 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :payment_date, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }

  scope :sorted, -> { order(payment_date: :asc) }
end
