class CreateUserRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :user_relationships do |t|
      t.integer :user_id
      t.integer :relationship_id

      t.timestamps
    end

    add_index :user_relationships, :user_id
    add_index :user_relationships, :relationship_id
    add_index :user_relationships, [:user_id, :relationship_id], unique: true
  end
end
