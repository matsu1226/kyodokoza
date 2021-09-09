class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :get_relationship
  before_action :check_posts_with_our_relationships, only: [:edit, :update, :destroy]


  def new
    @post = Post.new
  end

  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:post] = "記録を作成しました"
      redirect_to posts_path
    else
      render "posts/new"
    end
  end


  def index
    @month = params[:month] ? Time.parse(params[:month]) : Time.zone.now.beginning_of_month
    family_ids = @relationship.user_ids
    @posts = Post.where(user_id: family_ids, purchased_at: @month.all_month).order(purchased_at: :asc)
  end


  def narrow_down
    binding.pry
    # @month = params[:month] ? Time.parse(params[:month]) : Time.zone.now.beginning_of_month
    # family_ids = @relationship.user_ids
    # if params[:user_id]
    #   @posts = Post.where(user_id: params[:user_id], purchased_at: @month.all_month).order(purchased_at: :asc)
    # else
    #   @posts = Post.where(user_id: family_ids, purchased_at: @month.all_month).order(purchased_at: :asc)
    # end
  end
  # def narrow_down
  #   @posts = Post.where(user_id: params[:user_id]).order(purchased_at: :desc)
  #   respond_to do |format|
  #     format.html { redirect_to user_path(current_user) }
  #     format.json { render json: { user_id: params[:user_id] } }
  #   end
  # end


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
    def get_relationship
      @relationship = current_user.relationship
    end

    
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
