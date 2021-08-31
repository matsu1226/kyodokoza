class Category < ApplicationRecord
  has_many :posts

  validates :name, presence: true, length: { maximum: 8 }, uniqueness: true

end
