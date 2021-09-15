module StatsHelper

  # def manth/month_ajax
  def make_full_hash(ids, hash)
    array = ids - hash.keys
    array.count.times do |i|
      array.insert(2*i+1, 0)
    end
    return Hash[*array].merge(hash).sort.to_h
  end

  def make_pie_chart(price_array, target_price_array)
    @pie_chart = []
    price_array.zip(target_price_array) do |price, target_price|
      @pie_chart.push(price + [].push(target_price))
    end
  end

  def make_pie_chart_colors(ids)
    @pie_chart_colors = Category.where(id: ids).map {|elm| elm.color }
  end
  
  def make_pie_chart_sum(pie_chart)
    @pie_chart_sum = 0 
    @pie_chart.map{ |elm| @pie_chart_sum += elm[1] }
  end

  def price_diff_color(num1, num2)
    if num1-num2 < 0
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
end
