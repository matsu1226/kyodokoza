class IncomesController < ApplicationController
  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship
  before_action :check_incomes_with_our_relationships, only: [:edit, :update, :destroy]

  def new
    @income = Income.new
  end

  def create
    @income = Income.new(income_params)
    if @income.save
      flash[:success] = "記録を作成しました"
      redirect_to new_income_path
    else
      flash[:warning] = "正しい値を入力してください"
      render "posts/new"
    end
  end

  def edit
    @income = Income.find_by(id: params[:id])
  end

  def update
    @income = Income.find_by(id: params[:id])
    if @income.update(income_params)
      flash[:post] = "編集に成功しました"
      redirect_to posts_path
    else
      flash[:warning] = "正しい値を入力してください"
      render "edit"
    end
  end

  def destroy
    @income = Income.find_by(id: params[:id])
    @income.destroy
    redirect_to posts_path
    flash[:post] = "記録をを削除しました"
  end


  private 
    def income_params
      params.require(:income).permit(:user_id, :content, :price, :payment_at)
    end


    def check_incomes_with_our_relationships
      income = Income.find_by(id: params[:id])
      if income.user.relationship != @relationship
        flash[:post] = "あなた以外の家族の情報は閲覧できません"
        redirect_to posts_path
      end
    end

    # def sum_posts_price(posts)
    #   sum = 0
    #   posts.each do |post| 
    #     sum += post.price
    #   end
    #   return sum
    # end
end
