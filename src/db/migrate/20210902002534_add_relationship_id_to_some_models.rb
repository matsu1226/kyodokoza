class AddRelationshipIdToSomeModels < ActiveRecord::Migration[6.1]
  def change
    remove_index :relationships, name: :index_relationships_on_from_user_id_and_to_user_id
    remove_index :relationships, name: :index_relationships_on_from_user_id
    remove_index :relationships, name: :index_relationships_on_to_user_id
    remove_column :relationships, :from_user_id, :integer
    remove_column :relationships, :to_user_id, :integer
    add_column :users, :relationship_id, :integer
    remove_column :posts, :user_id, :integer
    add_column :posts, :relationship_id, :integer
  end
end
