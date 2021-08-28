class AddInvitaionToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :invitation_digest, :string
    add_column :users, :invitation_made_at, :datetime
  end
end
