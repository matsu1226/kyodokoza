class StatsController < ApplicationController
  before_action :get_relationship

  def month
    @month = Time.zone.now.beginning_of_month
    family_category_ids = @relationship.category_ids  # [1, 2, 3, 4, 5, 6, 7]
    category_group = Post.where(category_id: family_category_ids).month(@month).group("category_id").sum(:price)
    # {5=>550, 4=>1401522}
    array = family_category_ids - category_group.keys   # [1,2,3,6,7]
    array.count.times do |i|
      array.insert(2*i+1, 0)
    end   # [1, 0, 2, 0, 3, 0, 6, 0, 7, 0]
    # Hash[*array] => {1=>0, 2=>0, 3=>0, 6=>0, 7=>0}
    @pie_chart = Hash[*array].merge(category_group).sort.to_h   # {5=>550, 4=>1401522, 1=>0, 2=>0, 3=>0, 6=>0, 7=>0}
    @pie_chart_colors = Category.where(id: @pie_chart.keys).map {|c| c.color }
    @pie_chart_sum = @pie_chart.values.inject(:+)
  end

  def month_ajax
    @month = Time.parse(params[:month]) 
    family_category_ids = @relationship.category_ids
    category_group = Post.where(category_id: family_category_ids).month(@month).group("category_id").sum(:price)
    array = family_category_ids - category_group.keys
    array.count.times do |i|
      array.insert(2*i+1, 0)
    end
    @pie_chart = Hash[*array].merge(category_group).sort.to_h
    @pie_chart_colors = Category.where(id: @pie_chart.keys).map {|c| c.color }
    @pie_chart_sum = @pie_chart.values.inject(:+)
  end


  def year
    @month = Time.zone.now.beginning_of_month
    @year = Time.local(Time.now.year, 1, 1, 9, 00, 00)

    family_category_ids = @relationship.category_ids  # [1, 2, 3, 4, 5, 6, 7]
    category_group = Post.where(category_id: family_category_ids, purchased_at: @month).group("category_id").sum(:price)
    # {5=>550, 4=>1401522}
    array = family_category_ids - category_group.keys   # [1,2,3,6,7]
    array.count.times do |i|
      array.insert(2*i+1, 0)
    end   # [1, 0, 2, 0, 3, 0, 6, 0, 7, 0]
    # Hash[*array] => {1=>0, 2=>0, 3=>0, 6=>0, 7=>0}
    @pie_chart = Hash[*array].merge(category_group).sort.to_h   # {5=>550, 4=>1401522, 1=>0, 2=>0, 3=>0, 6=>0, 7=>0}
    @pie_chart_colors = Category.where(id: @pie_chart.keys).map {|c| c.color }
    @pie_chart_sum = @pie_chart.values.inject(:+)
  end


  def year_ajax
    @month = Time.parse(params[:month]) 
    family_category_ids = @relationship.category_ids
    category_group = Post.where(category_id: family_category_ids).month(@month).group("category_id").sum(:price)
    array = family_category_ids - category_group.keys
    array.count.times do |i|
      array.insert(2*i+1, 0)
    end
    @pie_chart = Hash[*array].merge(category_group).sort.to_h
    @pie_chart_colors = Category.where(id: @pie_chart.keys).map {|c| c.color }
    @pie_chart_sum = @pie_chart.values.inject(:+)

    @bar_chart= [
      {
        name: "Fantasy & Sci Fi", 
        data: [["2010", 10], ["2020", 16], ["2030", 28]]
      },
      {
        name: "Romance", 
        data: [["2010", 24], ["2020", 22], ["2030", 19]]
      },
      {
        name: "Mystery/Crime", 
        data: [["2010", 20], ["2020", 23], ["2030", 29]]
      }
    ]
  end

  private 
    def  get_relationship
      @relationship = current_user.relationship
    end
end
