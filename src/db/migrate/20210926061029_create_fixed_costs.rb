class CreateFixedCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :fixed_costs do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :price
      t.text :content
      t.integer :payment_date

      t.timestamps
    end

    add_column :posts, :fixed_costed, :boolean, default: false
    add_column :incomes, :fixed_costed, :boolean, default: false
  end
end
