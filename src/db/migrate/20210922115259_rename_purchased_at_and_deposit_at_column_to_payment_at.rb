class RenamePurchasedAtAndDepositAtColumnToPaymentAt < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :purchased_at, :payment_at
    rename_column :incomes, :deposit_at, :payment_at
  end
end
