class CategoriesController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = Category.all
  end

  def new
  end

  def edit
  end
end
