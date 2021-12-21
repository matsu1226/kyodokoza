module StatsHelper
  def price_color(price_diff)
    if price_diff.is_a?(Integer) && price_diff.negative?
      '#ff4500'
    else
      '#000'
    end
  end

  def fixed_costed_color(post)
    if post.fixed_costed
      'background-color: #f4f4ff ;'
    else
      'background-color: #fff ;'
    end
  end

  # 今月以降は残高を表示させない
  def set_future_month_count(year, array)
    today = Time.zone.now.to_date
    today_year = today.year
    year_of_year = year.to_date.year
    if year_of_year == today_year
      count = 12 - today.month
    elsif year_of_year > today_year
      count = 12
    elsif year_of_year < today_year
      count = 0
    end

    array.pop(count)
    count.times do |_i|
      array.push('bar')
    end
  end

  # views

  def yen(value)
    if value == 'bar'
      ' - '
    elsif value
      "¥ #{value.to_s(:delimited)}"
    else
      "¥ #{0.to_s(:delimited)}"
    end
  end

  def plus_minus(value)
    if value == 'bar'
      ' - '
    elsif value >= 0
      "+#{value.to_s(:delimited)}"
    else
      value.to_s(:delimited).to_s
    end
  end
end
