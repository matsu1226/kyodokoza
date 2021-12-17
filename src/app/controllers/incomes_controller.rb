class IncomesController < ApplicationController
  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship
  before_action :set_and_check_income                 , only: [:edit, :update, :destroy]
  before_action :check_incomes_with_our_relationships , only: [:edit, :update, :destroy]

  def new
    @income = Income.new
  end

  def create
    @income = Income.new(income_params)
    if @income.save
      flash[:success] = "#{@income.price}円の収入を作成しました"
      redirect_to new_income_path
    else
      flash[:warning] = "正しい値を入力してください"
      render "new"
    end
  end

  def edit
  end

  def update
    if @income.update(income_params)
      flash[:success] = "#{income_params[:price]}円の収入の編集に成功しました"
      redirect_to posts_path
    else
      flash[:warning] = "正しい値を入力してください"
      render "edit"
    end
  end

  def destroy
    @income.destroy
    redirect_to posts_path
    flash[:success] = "#{@income.price}円の収入を削除しました"
  end


  private 
    def income_params
      params.require(:income).permit(:user_id, :content, :price, :payment_at)
    end

    def set_and_check_income
      @income = Income.find(params[:id])
      # find_byはnilを返す。findは例外を返す。
    end

    def check_incomes_with_our_relationships
      if @income.user.relationship != @relationship
        flash[:post] = "あなた以外の家族の情報は閲覧できません"
        redirect_to posts_path
      end
    end

end
