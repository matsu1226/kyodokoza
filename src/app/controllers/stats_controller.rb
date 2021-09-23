class StatsController < ApplicationController
  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship

  def month
    @month = Time.zone.now.beginning_of_month
    @family_category_ids = @relationship.category_ids

    @pie_chart = []
    @family_category_ids.each do |c_id|
      @pie_chart.push(
        [Category.find_by(id: c_id).name, 
          post_where_month_sum(@relationship.users, c_id, @month)]
      )
    end
    @pie_chart_colors = Category.where(id: @family_category_ids).map(&:color)

    @month_post_total = Post.where(user_id: @relationship.users, category_id: @family_category_ids).month(@month).sum(:price)
    @month_target_total = Category.where(id: @family_category_ids).sum(:target_price)

    @month_target_array = []
    @family_category_ids.count.times do |i|
      @month_target_array.push(
        Category.where(id: @family_category_ids[i]).sum(:target_price)
      )
    end
  end

  
  def month_ajax
    @month = Time.parse(params[:month]) 
    @family_category_ids = @relationship.category_ids

    @pie_chart = []
    @family_category_ids.each do |c_id|
      @pie_chart.push(
        [Category.find_by(id: c_id).name, 
          post_where_month_sum(@relationship.users, c_id, @month)]
      )
    end
    @pie_chart_colors = Category.where(id: @family_category_ids).map(&:color)
  end


  def year
    @year = Time.zone.local(Time.now.year, 1, 1, 9, 00, 00)
    
    @income_array = []    # 収入合計
    @post_array = []      # 支出合計
    @month_total_array = []   # 収支(収入合計と支出合計の差)
    @remainder_array = []     # 残高
    
    every_months = []    # @yearの月配列( [1/1 2/1, 3/1, … 12/1] )
    remainder = 0
    family_category_ids = @relationship.category_ids
    family_posts = Post.where(user_id: @relationship.users)

    12.times do |j|
      every_months.push(
      Time.zone.local(@year.year, j+1, 1, 00, 00, 00)
      ) 
      @income_array.push(
        Income.where(user_id: @relationship.users).month(every_months[j]).sum(:price)
      )
      @post_array.push(
        Post.where(user_id: @relationship.users).month(every_months[j]).sum(:price)
      )
      @month_total_array.push(
        @income_array[j] - @post_array[j]
      )
      remainder = remainder + @month_total_array[j]
      @remainder_array.push(remainder)
    end

    @bar_chart = []
    # カテゴリごとの繰り返し
    family_category_ids.length.times do |i| 
      post_array_every_category = []
        # 月ごとの繰り返し
        12.times do |j|
          post_array_every_category.push([
            "#{j+1}月",
            family_posts.where(category_id: family_category_ids[i]).month(every_months[j]).sum(:price)
          ])
        end

      @bar_chart.push({
        name: Category.find_by(id: family_category_ids[i]).name, 
        data: post_array_every_category,
        color: Category.find_by(id: family_category_ids[i]).color
      })
    end
  
  end


  def year_ajax
    @year = Time.parse(params[:year]) 
    @income_array = []    # 収入合計
    @post_array = []      # 支出合計
    @month_total_array = []   # 収支(収入合計と支出合計の差)
    @remainder_array = []     # 残高
    
    every_months = []    # @yearの月配列( [1/1 2/1, 3/1, … 12/1] )
    remainder = 0
    family_category_ids = @relationship.category_ids
    family_posts = Post.where(user_id: @relationship.users)

    12.times do |j|
      every_months.push(
      Time.zone.local(@year.year, j+1, 1, 00, 00, 00)
      ) 
      @income_array.push(
        Income.where(user_id: @relationship.users).month(every_months[j]).sum(:price)
      )
      @post_array.push(
        Post.where(user_id: @relationship.users).month(every_months[j]).sum(:price)
      )
      @month_total_array.push(
        @income_array[j] - @post_array[j]
      )
      remainder = remainder + @month_total_array[j]
      @remainder_array.push(remainder)
    end

    @bar_chart = []
    # カテゴリごとの繰り返し
    family_category_ids.length.times do |i| 
      post_array_every_category = []
        # 月ごとの繰り返し
        12.times do |j|
          post_array_every_category.push([
            "#{j+1}月",
            family_posts.where(category_id: family_category_ids[i]).month(every_months[j]).sum(:price)
          ])
        end

      @bar_chart.push({
        name: Category.find_by(id: family_category_ids[i]).name, 
        data: post_array_every_category,
        color: Category.find_by(id: family_category_ids[i]).color
      })
    end
  end

  private
end


    # @bar_chartの完成イメージ
    # @bar_chart = [
    #   {
    #     name: "固定費", 
    #     data: [["1月", 75000], ["2月", 75000],["3月", 75000], ["12月", 75000]]
    #   },
    #   {
    #     name: "食費", 
    #     data: [["1月", 35000], ["2月", 34500],["3月", 39000], ["12月", 37000]]
    #   },
    #   {
    #     name: "通信費", 
    #     data: [["1月", 5000], ["2月", 5000],["3月", 5500], ["12月", 5000]]
    #   },
    #   {
    #     name: "飲み会", 
    #     data: [["1月", 5000], ["2月", 3000],["3月", 15000], ["12月", 15000]]
    #   },
    #   {
    #     name: "雑費", 
    #     data: [["1月", 1330], ["2月", 3000],["3月", 2400], ["12月", 14000]]
    #   },
    #   {
    #     name: "交通費", 
    #     data: [["1月", 5000], ["2月", 1200],["3月", 1000], ["12月", 5000]]
    #   },
    # ]