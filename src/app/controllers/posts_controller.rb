class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :check_have_relationship
  before_action :get_relationship
  before_action :check_posts_with_our_relationships, only: [:edit, :update, :destroy]


  def new
    @post = Post.new
  end

  
  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "記録を作成しました"
      redirect_to new_post_path
    else
      render "posts/new"
    end
  end


  def index
    @sum_target_price = Category.where(id: @relationship.category_ids).sum(:target_price)
    @month = Time.zone.now.beginning_of_month.to_datetime
    family_user_ids = @relationship.user_ids
    family_category_ids = @relationship.category_ids
    @posts = narrow_downing_posts(family_user_ids, family_category_ids, @month)
  end


  def narrow_down
    make_sum_target_price(@relationship.categories) # @sum_target_priceの生成
    # (1)月の変更 or (2)ユーザー絞り込み
    # (1)例:現在9月の画面
    # [view] posts_narrow_down_path(month: @month.prev_month) 
    # [controller] params[:month] = @変更前month.prev_month = 2021/08
    # [controller] @変更後month = @変更前month.prev_month = 2021/08
    # (2)例:現在9月の画面
    # [view] posts_narrow_down_path(month: @month)
    # [controller] params[:month] = @変更前month = 2021/09
    # [controller] @変更後month = @変更前month = 2021/09

    @month = Time.parse(params[:month]) 

    family_user_ids = @relationship.user_ids
    family_category_ids = @relationship.category_ids

    if params[:user_id].blank? && params[:category_id].blank?
      @posts = narrow_downing_posts(family_user_ids, family_category_ids, @month)
    elsif params[:user_id].present?
      @posts = narrow_downing_posts(params[:user_id], family_category_ids, @month)
    elsif params[:category_id].present?
      @posts = narrow_downing_posts(family_user_ids, params[:category_id], @month)
    else  # categoryもuserも指定
      @posts = narrow_downing_posts(params[:user_id], params[:category_id], @month)
    end
  end
  

  def edit
    @post = Post.find_by(id: params[:id])
  end
  
  
  def update
    @post = Post.find_by(id: params[:id])
    if @post.update(post_params)
      flash[:post] = "編集に成功しました"
      redirect_to posts_path
    else
      render "edit"
    end
  end


  def destroy
    @post = Post.find_by(id: params[:id]) 
    @post.destroy
    redirect_to posts_path
    flash[:post] = "記録をを削除しました"
  end


  private 
    def post_params
      params.require(:post).permit(:category_id, :user_id, :content, :price, :purchased_at)
    end


    def check_posts_with_our_relationships
      post = Post.find_by(id: params[:id])
      if post.user.relationship != @relationship
        flash[:post] = "あなた以外の家族の情報は閲覧できません"
        redirect_to posts_path
      end
    end

end
