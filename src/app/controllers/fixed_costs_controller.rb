class FixedCostsController < ApplicationController
  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship
  # before_action :check_posts_with_our_relationships, only: [:edit, :update, :destroy]
  
  
  def index
    family_user_ids = @relationship.user_ids
    family_category_ids = @relationship.category_ids
    @fixed_costs = FixedCost.where(user_id: family_user_ids).sorted
    # @posts = narrow_downing_posts(family_user_ids, family_category_ids, @month)
  end


  def new
    @fixed_cost = FixedCost.new
  end


  def create
    @fixed_cost = FixedCost.new(fixed_cost_params)
    if @fixed_cost.save
      flash[:success] = "テンプレートを作成しました"
      redirect_to fixed_costs_path
    else
      flash[:warning] = "正しい値を入力してください"
      render "fixed_costs/new"
    end
  end


  def edit
    @fixed_cost = FixedCost.find_by(id: params[:id])
  end


  def update
    @fixed_cost = FixedCost.find_by(id: params[:id])
    if @fixed_cost.update(fixed_cost_params)
      flash[:info] = "テンプレートを更新しました"
      redirect_to fixed_costs_path
    else
      flash[:warning] = "正しい値を入力してください"
      render "fixed_costs/edit"
    end
  end

  
  def destroy
    @fixed_cost = FixedCost.find_by(id: params[:id])
    @fixed_cost.destroy
    redirect_to fixed_costs_path
    flash[:warning] = "テンプレートを削除しました"

  end

  def exec
    today = Time.zone.today
    family_user_ids = @relationship.user_ids

    # checked_data = params[:fixed_cost].keys
    if params[:fixed_cost] && params[:fixed_cost].keys
      fixed_costs = FixedCost.where(id: params[:fixed_cost].keys)
      # fixed_costs_count = fixed_costs.count
      # fixed_costs = params[:fixed_cost].keys    
      # fixed_costs = FixedCost.where(user_id: family_user_ids)
  
      before_post_count = Post.where(user_id: family_user_ids).month(today)
  
      fixed_costs.each do |fixed_cost|
        @post = Post.new(user_id: fixed_cost.user_id, 
                        category_id: fixed_cost.category_id,
                        content: fixed_cost.content,
                        price: fixed_cost.price,
                        payment_at: Time.local(today.year, today.month, fixed_cost.payment_date, 12, 00, 00),
                        fixed_costed: true
                        )
        @post.save                  
      end
      flash[:fixed_cost] = "記録が正しく反映されました"
      redirect_to fixed_costs_path
    else
      flash[:fixed_cost] = "テンプレートが選択されていません"
      redirect_to fixed_costs_path
    end

  end


  private

    def fixed_cost_params
      params.require(:fixed_cost).permit(:user_id, :category_id, :content, :price, :payment_date)
    end
end
