class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :from_user_id
      t.integer :to_user_id

      t.timestamps
    end
    add_index :relationships, :from_user_id
    add_index :relationships, :to_user_id
    add_index :relationships, [:from_user_id, :to_user_id], unique: true
  end
end
