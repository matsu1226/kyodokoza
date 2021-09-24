module StatsHelper
  
  def price_color(price_diff)
    if price_diff.is_a?(Integer) && price_diff < 0
      "#ff4500"
    else
      "#000"
    end
  end

  # 今月以降は残高を表示させない
  def set_future_month_count(year, array)
    beginning_of_year = year.to_date
    today = Time.zone.now.to_date
    if beginning_of_year.year == today.year 
      months_of_beginning_of_year = beginning_of_year.year * 12 + beginning_of_year.month
      months_of_today = today.year * 12 + today.month
      month_count = months_of_today -  months_of_beginning_of_year
      @future_month_count = 12 - month_count - 1
    elsif beginning_of_year.year > today.year
      @future_month_count = 12
    elsif beginning_of_year.year < today.year
      @future_month_count = 0
    end

    array.pop(@future_month_count)
    (@future_month_count).times do |i|
      array.push("bar")
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


end
