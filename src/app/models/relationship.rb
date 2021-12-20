class Relationship < ApplicationRecord
  has_many :user_relationships, dependent: :destroy
  has_many :users, through: :user_relationships
  has_many :categories, dependent: :destroy

  validates :name, presence: true, length: { maximum: 6 }
end
