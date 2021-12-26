class PostsController < ApplicationController
  include PostIncomeActions

  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship
  before_action :set_and_check_post, only: %i[edit update destroy]
  before_action :check_posts_with_our_relationships, only: %i[edit update destroy]

  def new
    @post = Post.new
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
    @month = Time.zone.now.beginning_of_month.to_datetime
    family_user_ids = @relationship.user_ids
    family_category_ids = @relationship.category_ids
    @posts = Post.narrow_down(family_user_ids, family_category_ids, @month).includes([:user, :category])
    @sum_posts_price = @posts.map(&:price).inject(:+)
    @sum_target_price = Category.where(id: @relationship.category_ids).sum(:target_price)
    @price_diff = @sum_target_price - @sum_posts_price
  end

  def narrow_down
    @month = Time.zone.parse(params[:month])

    family_user_ids = @relationship.user_ids
    family_category_ids = @relationship.category_ids

    if params[:price] == 'income'
      @posts = Income.narrow_down(family_user_ids, @month).includes(:user)
      @sum_posts_price = @posts.map(&:price).inject(:+)
      @sum_target_price = 'bar'
      @price_diff = 'bar'
    # 以下3条件は全て params[:price] == 'post'
    elsif params[:user_id].blank? && params[:category_id].blank?
      @posts = Post.narrow_down(family_user_ids, family_category_ids, @month).includes([:user, :category])
      @sum_posts_price = @posts.map(&:price).inject(:+)
      @sum_target_price = Category.where(id: family_category_ids).sum(:target_price)
      @price_diff = @sum_target_price - @sum_posts_price
    elsif params[:user_id].present?
      @posts = Post.narrow_down(params[:user_id], family_category_ids, @month).includes([:user, :category])
      @sum_posts_price = @posts.map(&:price).inject(:+)
      @sum_target_price = 'bar'
      @price_diff = 'bar'
    else # params[:category_id].present?
      @posts = Post.narrow_down(family_user_ids, params[:category_id], @month).includes([:user, :category])
      @sum_posts_price = @posts.map(&:price).inject(:+)
      @sum_target_price = Category.where(id: params[:category_id]).sum(:target_price)
      @price_diff = @sum_target_price - @sum_posts_price
    end
  end

  private

  def strong_params
    params.require(:post).permit(:category_id, :user_id, :content, :price, :payment_at)
  end

  def set_and_check_post
    @post = Post.find(params[:id])
    # find_byはnilを返す。findは例外を返す。
  end

  def check_posts_with_our_relationships
    return if @post.user.relationship == @relationship

    flash[:post] = 'あなた以外の家族の情報は閲覧できません'
    redirect_to posts_path
  end

  def created_instance
    @post = Post.new(strong_params)
  end

  def updated_instance
    @post
  end

  def path_after_update
    posts_path
  end

  def record_type
    "支出"
  end
end
