class Category < ApplicationRecord
  belongs_to :relationship
  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 8 }, uniqueness: true
  validates :relationship_id, presence: true

end
