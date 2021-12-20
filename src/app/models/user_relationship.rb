class UserRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :relationship

  validates :user_id, presence: true
  validates :relationship_id, presence: true
end
