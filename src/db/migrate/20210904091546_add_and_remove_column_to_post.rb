class AddAndRemoveColumnToPost < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :relationship_id, :integer
    add_column :posts, :user_id, :integer
  end
end
