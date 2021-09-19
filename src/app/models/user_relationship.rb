class UserRelationship < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :relationship, foreign_key: "relationship_id"

  validates :user_id, presence: true
  validates :relationship_id, presence: true
end
