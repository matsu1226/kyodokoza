class CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :get_relationship
  before_action :check_category_with_our_relationships, only: [:edit, :update, :destroy]


  def index
    @categories = @relationship.categories
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
    flash[:info] = "カテゴリを削除しました"
    redirect_to categories_path
  end


  private 
    def get_relationship
      @relationship = current_user.relationship
    end

    def category_params
      params.require(:category).permit(:name, :color, :content)
    end

    def check_category_with_our_relationships
      category = Category.find_by(id: params[:id])
      if category.relationship != @relationship
        flash[:danger] = "あなた以外の家族の情報は閲覧できません"
        redirect_to categories_path
      end
    end
end
