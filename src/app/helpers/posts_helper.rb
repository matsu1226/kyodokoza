module PostsHelper

  def day_of_week(date)
    days = ["(日)", "(月)", "(火)", "(水)", "(木)", "(金)", "(土)"]
    days[date.wday]
  end

  def sum_posts_price(posts)
    sum = 0
    posts.each do |post| 
      sum += post.price
    end
    return sum
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

  def narrow_downing_posts(user_id_set, category_id_set, month)
    # Post.where(user_id: user_id_set, category_id: category_id_set, purchased_at: @month.all_month).order(purchased_at: :asc)
    Post.where(user_id: user_id_set, category_id: category_id_set).month(month).sorted
  end

end
