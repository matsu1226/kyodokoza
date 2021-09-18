class CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship
  before_action :get_color_list, only: [:new, :create, :edit, :update]
  before_action :check_category_with_our_relationships, only: [:edit, :update, :destroy]


  def index
    @categories = @relationship.categories
    # @sum_target_price = 0 
    # @categories.each { |c| @sum_target_price += c.target_price }
    @sum_target_price = Category.where(id: @relationship.category_ids).sum(:target_price)
  end


  def new
    @category = Category.new
  end
  

  def create
    @category = @relationship.categories.build(category_params)
    if @category.save
      flash[:success] = "カテゴリを作成しました"
      redirect_to categories_path
    else
      render "categories/new"
    end

  end


  def edit
    @category = Category.find_by(id: params[:id])
  end


  def update
    @category = Category.find_by(id: params[:id])
    if @category.update(category_params)
      flash[:success] = "カテゴリを更新しました"
      redirect_to categories_path
    else
      render "categories/edit"
    end
  end


  def destroy
    @category = Category.find_by(id: params[:id])
    @category.destroy
    flash[:danger] = "カテゴリを削除しました"
    redirect_to categories_path
  end



  private 
    def category_params
      params.require(:category).permit(:name, :color, :content, :target_price)
    end

    def check_category_with_our_relationships
      category = Category.find_by(id: params[:id])
      if category.relationship != @relationship
        flash[:danger] = "あなた以外の家族の情報は閲覧できません"
        redirect_to categories_path
      end
    end

    def get_color_list
      @color_list = ["#ff4500","#ff8c00","#ffd700","#006400","#0000cd","#4169e1",
                    "#800080","#ff1493","#b8860b","#696969","#e9967a"]
    end
end
