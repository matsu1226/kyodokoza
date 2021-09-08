class AddParchacedAtToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :purchased_at, :datetime
  end
end
