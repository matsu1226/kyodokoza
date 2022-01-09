class AddSendWeeklyMailToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :send_weekly_mail, :boolean, default: true
  end
end
