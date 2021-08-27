class AddNameToRelationships < ActiveRecord::Migration[6.1]
  def change
    add_column :relationships, :name, :string
  end
end
