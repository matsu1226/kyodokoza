class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :content, presence: true, length: { maximum: 30 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :payment_at, presence: true

  scope :month,
        ->(month) { where(payment_at: month.all_month) }
  scope :sorted,
        -> { order(payment_at: :desc) }
  scope :narrow_down,
        ->(user_id, category_id, month) { where(user_id: user_id, category_id: category_id).month(month).sorted }


	def self.for_guest(content, price, category, user)
		find_or_create_by!(content: content,
											 price: price,
											 payment_at: Time.zone.now,
											 category_id: category.id,
											 user_id: user.id)
	end
end
