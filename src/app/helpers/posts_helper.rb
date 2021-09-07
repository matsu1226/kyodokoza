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
    sum.to_s(:delimited)
  end
end
