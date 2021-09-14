class AddTargetPriceToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :target_price, :integer
  end
end
