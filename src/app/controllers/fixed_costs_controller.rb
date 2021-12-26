class FixedCostsController < ApplicationController
  include PostIncomeActions

  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship
  before_action :set_and_check_fixed_cost, only: %i[edit update destroy]

  def new
    @fixed_cost = FixedCost.new
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

  def index
    @fixed_costs = FixedCost.where(user_id: @relationship.user_ids).sorted
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

  def strong_params
    params.require(:fixed_cost).permit(:user_id, :category_id, :content, :price, :payment_date)
  end

  def set_and_check_fixed_cost
    @fixed_cost = FixedCost.find(params[:id])
    # find_byはnilを返す。findは例外を返す。
  end

  def created_instance
    @fixed_cost = FixedCost.new(strong_params)
  end

  def updated_instance
    @fixed_cost
  end

  def path_after_update
    fixed_costs_path
  end

  def record_type
    "テンプレート"
  end

end
