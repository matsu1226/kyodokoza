class ReportController < ApplicationController
  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship

  def single
    @month = Time.zone.parse(params[:month])
    family_user_ids = @relationship.user_ids
    family_category_ids = @relationship.category_ids
    @posts = Post.narrow_down(family_user_ids, family_category_ids, @month)
    @file_name = "#{@month.year}_#{@month.month}"

    respond_to do |format|
      format.html
      format.xlsx do
        # ファイル名W
        response.headers['Content-Disposition'] = "attachment; filename=#{@file_name}.xlsx"
      end
    end
  end

  def multiple
    @posts = Post.all
  end

  def output_multiple
    from_month = Date.new(params['from_date(1i)'].to_i,
                          params['from_date(2i)'].to_i)
    to_month = Date.new(params['to_date(1i)'].to_i,
                        params['to_date(2i)'].to_i)
    if from_month <= to_month
      month_array = (from_month..to_month).map(&:beginning_of_month).uniq
      family_user_ids = @relationship.user_ids
      family_category_ids = @relationship.category_ids
      @excels = []
      @excels = month_array.map do |month|
        Post.narrow_down(family_user_ids, family_category_ids, month)
      end
      @file_name = "#{from_month.year}_#{from_month.month}_to_#{to_month.year}_#{to_month.month}"

      respond_to do |format|
        format.html
        format.xlsx do
          response.headers['Content-Disposition'] = "attachment; filename=#{@file_name}.xlsx"
        end
      end
    else
      redirect_to report_multiple_path
      flash[:warning] = '正しい年月を入力してください'
    end
  end

  private

  def redirect_to_user_path
    redirect_to user_path(current_user)
  end
end
