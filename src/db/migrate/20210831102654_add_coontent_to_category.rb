class AddCoontentToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :color, :string
    add_column :categories, :content, :string
  end
end
