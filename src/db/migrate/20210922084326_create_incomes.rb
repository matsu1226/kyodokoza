class CreateIncomes < ActiveRecord::Migration[6.1]
  def change
    create_table :incomes do |t|
      t.integer :user_id
      t.integer :price
      t.text :content
      t.datetime :deposit_at

      t.timestamps
    end
  end
end
