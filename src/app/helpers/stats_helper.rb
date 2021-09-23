module StatsHelper

  # def manth/month_ajax
  def post_where_month_sum(user_id, category_id, month)
    Post.where(user_id: user_id, category_id: category_id).month(month).sum(:price)
  end
  
  def price_color(price_diff)
    if price_diff.is_a?(Integer) && price_diff < 0
      "#ff4500"
    else
      "#000"
    end
  end

  

  # views
  
  def yen(value)
    if value == "bar"
      " - "
    elsif value
      "¥ #{value.to_s(:delimited)}"
    else
      "¥ #{0.to_s(:delimited)}"
    end
  end

  def plus_minus(value)
    if value >= 0
      " + #{value.to_s(:delimited)}"
    else
      " - #{value.to_s(:delimited)}"
    end
  end

  def month_payment(category_id)
    post_where_month_sum(@relationship.users, category_id, @month)
  end

  def month_target(category_id)
    Category.where(id: category_id).sum(:target_price)
  end


end
