class Category < ApplicationRecord
  belongs_to :relationship
  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 8 }
  validates :color, presence: true

  validates :relationship_id, presence: true
  validates :target_price, numericality: { greater_than_or_equal_to: 0 }
  # numerrically は自動でpresence: true => presence: true出ないようにしいたなら、allow_nilを付記

  def self.for_guest(name, color, content, relationship_id, target_price)
    find_or_create_by!(name: name,
                       color: color,
                       content: content,
                       relationship_id: relationship_id,
                       target_price: target_price)
  end

  def self.destroy_for_guest(current_user, guest)
    where(relationship_id: guest.relationship.id).each(&:destroy)
  end
  
end
