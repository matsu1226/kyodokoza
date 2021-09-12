module PostsHelper

  def day_of_week(date)
    days = ["(日)", "(月)", "(火)", "(水)", "(木)", "(金)", "(土)"]
    days[date.wday]
  end

  def sum_posts_price
    sum = 0
    @posts.each do |post| 
      sum += post.price
    end
    yen(sum)
  end

  def narrow_down_select(attribute, array )
    id = "#{attribute}_id".to_sym
    # association_method = "#{attribute}".pluralize
    select_tag id , options_from_collection_for_select(array, "id", "name",{ selected: params[id] }), 
                            {prompt: 'all',
                            class: 'form-select narrow_down_select col-2',
                            data: { remote: true,
                                    url: posts_narrow_down_path(month: @month) }}
  end

  def yen(value)
    if value
      "¥ #{value.to_s(:delimited)}"
    else
      "¥ #{0.to_s(:delimited)}"
    end
  end

end
