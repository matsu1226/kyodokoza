class Category < ApplicationRecord
  belongs_to :relationship
  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 8 }
  validates :color, presence: true

  validates :relationship_id, presence: true
  validates :target_price, numericality: { greater_than_or_equal_to: 0 }
  # numerrically は自動でpresence: true => presence: true出ないようにしいたなら、allow_nilを付記
end
