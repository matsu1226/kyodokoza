class RemoveRelationshipIdFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :relationship_id, :integer
  end
end
