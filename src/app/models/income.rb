class Income < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"

  validates :content, presence: true, length: { maximum: 30 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
  validates :payment_at, presence: true

  scope :month, -> (month) { where(payment_at: month.all_month) }
  scope :sorted, -> { order(payment_at: :asc) }

end
