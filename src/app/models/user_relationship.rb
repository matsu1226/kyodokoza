class UserRelationship < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :relationship, foreign_key: "relationship_id"
end
