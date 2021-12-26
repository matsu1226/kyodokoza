class IncomesController < ApplicationController
  include PostIncomeActions

  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship
  before_action :set_and_check_income, only: %i[edit update destroy]
  before_action :check_incomes_with_our_relationships, only: %i[edit update destroy]

  def new
    @income = Income.new
  end

  def create
    create_record
  end

  def edit; end

  def update
    update_record
  end

  def destroy
    destroy_record
  end

  private

  def strong_params
    params.require(:income).permit(:user_id, :content, :price, :payment_at)
  end

  def set_and_check_income
    @income = Income.find(params[:id])
    # find_byはnilを返す。findは例外を返す。
  end

  def check_incomes_with_our_relationships
    return if @income.user.relationship == @relationship

    flash[:post] = 'あなた以外の家族の情報は閲覧・編集できません'
    redirect_to posts_path
  end

  def created_instance
    @income = Income.new(strong_params)
  end

  def updated_instance
    @income
  end

  def record_type
    "収入"
  end

end
