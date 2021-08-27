class Relationship < ApplicationRecord
  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"

  validates :name, presence: true
  validates :from_user_id, presence: true, uniqueness: true
  validates :to_user_id, presence: true, uniqueness: true
end
