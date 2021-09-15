module RelationshipsHelper
  def no_relationship
    current_user.relationship.nil?
  end

  def digest_and_token_is_password?(digest, token)
    BCrypt::Password.new(digest).is_password?(token)
  end
end
