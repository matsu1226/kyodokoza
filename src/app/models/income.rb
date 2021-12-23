class Income < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 30 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :payment_at, presence: true

  scope :month,
        ->(month) { where(payment_at: month.all_month) }
  scope :sorted,
        -> { order(payment_at: :asc) }
  scope :narrow_down,
        ->(user_id, month) { where(user_id: user_id).month(month).sorted }
end
