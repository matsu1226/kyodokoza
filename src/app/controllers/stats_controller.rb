class StatsController < ApplicationController
  before_action :logged_in_user
  before_action :get_relationship

  def month
    @month = Time.zone.now.beginning_of_month
    family_category_ids = @relationship.category_ids
    category_group_hash = Post.where(category_id: family_category_ids).month(@month).group("category_id").sum(:price)
    @pie_chart = make_full_hash(family_category_ids, category_group_hash )
    @pie_chart_colors = Category.where(id: @pie_chart.keys).map {|c| c.color }
    @pie_chart_sum = @pie_chart.values.inject(:+)
  end

  def month_ajax
    @month = Time.parse(params[:month]) 
    family_category_ids = @relationship.category_ids
    category_group_hash = Post.where(category_id: family_category_ids).month(@month).group("category_id").sum(:price)
    @pie_chart = make_full_hash(family_category_ids, category_group_hash )
    # ex => {1=>0, 2=>0, 3=>0, 4=>1401522 ,5=>550, 6=>0, 7=>0}
    @pie_chart_colors = Category.where(id: @pie_chart.keys).map {|c| c.color }
    @pie_chart_sum = @pie_chart.values.inject(:+)
  end


  def year
    @year = Time.local(Time.now.year, 1, 1, 9, 00, 00)
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
            Category.left_joins(:posts).select('categories.*, posts.purchased_at, posts.price')
            .where(id: family_category_ids[i], posts: { purchased_at: every_months.all_month} ).group("name").sum(:price).values[0]
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
            Category.left_joins(:posts).select('categories.*, posts.purchased_at, posts.price')
            .where(id: family_category_ids[i], posts: { purchased_at: every_months.all_month} ).group("name").sum(:price).values[0]
          ])
        end

      @bar_chart.push({
        name: Category.find_by(id: family_category_ids[i]).name, 
        data: month_name_and_sum_price_every_category,
        color: Category.find_by(id: family_category_ids[i]).color
      })
    end
  end


  private 
    def  get_relationship
      @relationship = current_user.relationship
    end

    def make_full_hash(ids, hash)
      array = ids - hash.keys
      array.count.times do |i|
        array.insert(2*i+1, 0)
      end
      return Hash[*array].merge(hash).sort.to_h
    end

end
