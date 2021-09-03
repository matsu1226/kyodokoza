class CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :get_relationship

  def index
    @categories = Category.all
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
  end

  def update

  end

  def destroy
    
  end

  private 
    def get_relationship
      @relationship = current_user.relationship
    end

    def category_params
      params.require(:category).permit(:name, :color, :content)
    end
end
