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
    @month = Time.zone.now.beginning_of_month
    family_category_ids = @relationship.category_ids
    
    @bar_chart = []
    # カテゴリごとの繰り返し
    family_category_ids.length.times do |i| 
      month_name_and_sum_price_every_category = []
        # 月ごとの繰り返し
        12.times do |j|
          every_months= Time.zone.local(@year.year, j+1, 1, 00, 00, 00)

          month_name_and_sum_price_every_category.push([
            "#{j+1}月",
            post_where_month_sum(@relationship.users, family_category_ids[i], every_months)
          ])
        end

      @bar_chart.push({
        name: Category.find_by(id: family_category_ids[i]).name, 
        data: month_name_and_sum_price_every_category,
        color: Category.find_by(id: family_category_ids[i]).color
      })
    end


    # [["1月", 75000], ["2月", 75000],["3月", 75000], ... ,["12月", 75000]],
    # [["1月", 35000], ["2月", 34500],["3月", 39000], ... ,["12月", 37000]],
    # [["1月", 5000], ["2月", 5000],["3月", 5500], ... ,["12月", 5000]],
    # [["1月", 5000], ["2月", 3000],["3月", 15000], ... ,["12月", 15000]],
    # [["1月", 1330], ["2月", 3000],["3月", 2400], ... ,["12月", 14000]],
    # [["1月", 5000], ["2月", 1200],["3月", 1000], ... ,["12月", 5000]]

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
  end


  def year_ajax
    # @year = Time.local(Time.now.year, 1, 1, 9, 00, 00)
    @year = Time.parse(params[:year]) 
    @month = Time.zone.now.beginning_of_month
    family_category_ids = @relationship.category_ids
    
    @bar_chart = []
    family_category_ids.length.times do |i| 
      month_name_and_sum_price_every_category = []
        # 月ごとの繰り返し
        12.times do |j|
          every_months= Time.local(@year.year, j+1, 1, 9, 00, 00)

          month_name_and_sum_price_every_category.push([
            "#{j+1}月",
            post_where_month_sum(@relationship.users, family_category_ids[i], every_months)
          ])
        end

      @bar_chart.push({
        name: Category.find_by(id: family_category_ids[i]).name, 
        data: month_name_and_sum_price_every_category,
        color: Category.find_by(id: family_category_ids[i]).color
      })
    end
  end

end
