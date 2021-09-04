class Category < ApplicationRecord
  belongs_to :relationship, foreign_key: "relationship_id"
  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 8 }
  validates :color, presence: true

  validates :relationship_id, presence: true

end
