module StatsHelper

  # def manth/month_ajax
  def post_where_month_sum(user_id, category_id, month)
    Post.where(user_id: user_id, category_id: category_id).month(month).sum(:price)
  end
  
  def price_color(target_price, payment)
    if target_price - payment < 0
      "#ff4500"
    else
      "#000"
    end
  end

  # views
  
  def yen(value)
    if value
      "¥ #{value.to_s(:delimited)}"
    else
      "¥ #{0.to_s(:delimited)}"
    end
  end

  def month_payment(category_id)
    post_where_month_sum(@relationship.users, category_id, @month)
  end

  def month_target(category_id)
    Category.where(id: category_id).sum(:target_price)
  end

end
