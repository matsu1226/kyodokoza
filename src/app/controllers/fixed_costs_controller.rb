class FixedCostsController < ApplicationController
  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship

  def index
    @fixed_costs = FixedCost.where(user_id: @relationship.user_ids).sorted
  end

  def new
    @fixed_cost = FixedCost.new
  end

  def create
    @fixed_cost = FixedCost.new(fixed_cost_params)
    if @fixed_cost.save
      flash[:success] = 'テンプレートを作成しました'
      redirect_to fixed_costs_path
    else
      flash[:warning] = '正しい値を入力してください'
      render 'fixed_costs/new'
    end
  end

  def edit
    @fixed_cost = FixedCost.find_by(id: params[:id])
  end

  def update
    @fixed_cost = FixedCost.find_by(id: params[:id])
    if @fixed_cost.update(fixed_cost_params)
      flash[:success] = 'テンプレートを更新しました'
      redirect_to fixed_costs_path
    else
      flash[:warning] = '正しい値を入力してください'
      render 'fixed_costs/edit'
    end
  end

  def destroy
    @fixed_cost = FixedCost.find_by(id: params[:id])
    @fixed_cost.destroy
    redirect_to fixed_costs_path
    flash[:warning] = 'テンプレートを削除しました'
  end

  def exec
    today = Time.zone.today
    if params[:fixed_cost]&.keys
      fixed_costs = FixedCost.where(id: params[:fixed_cost].keys)
      fixed_costs.each do |fixed_cost|
        @post = Post.new(user_id: fixed_cost.user_id,
                         category_id: fixed_cost.category_id,
                         content: fixed_cost.content,
                         price: fixed_cost.price,
                         payment_at: Time.zone.local(today.year, today.month, fixed_cost.payment_date, 12, 0o0, 0o0),
                         fixed_costed: true)
        @post.save
      end
      flash[:success] = '記録が正しく反映されました'
    else
      flash[:warning] = 'テンプレートが選択されていません'
    end
    redirect_to fixed_costs_path
  end

  private

  def fixed_cost_params
    params.require(:fixed_cost).permit(:user_id, :category_id, :content, :price, :payment_date)
  end
end
