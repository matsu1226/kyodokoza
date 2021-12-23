namespace :update_column do
  desc 'positionがnilの場合は0に置換する'
  task categories_position_to_zero: :environment do
    Category.where(position: nil).each do |c|
      c.update(position: 0)
    end
  end
end
