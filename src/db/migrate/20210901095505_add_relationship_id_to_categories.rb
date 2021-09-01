class AddRelationshipIdToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :relationship_id, :integer
  end
end
