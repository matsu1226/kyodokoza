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
      flash[:success] = "記録をを作成しました"
      redirect_to posts_path
    else
      render "posts/new"
    end
  end


  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.today
    family_ids = @relationship.user_ids
    @posts = Post.where(user_id: family_ids, created_at: @month.all_month)
  end

  # def table 
  #   respond_to do |format|
  #     format.html
  #     format.json {render json: EventDatatable.new(params)}
  #   end
  # end


  def edit
  end


  private 
    def get_relationship
      @relationship = current_user.relationship
    end

    
    def post_params
      params.require(:post).permit(:category_id, :user_id, :content, :price)
    end


    def check_posts_with_our_relationships
      post = Post.find_by(id: params[:id])
      if post.relationship != @relationship
        flash[:danger] = "あなた以外の家族の情報は閲覧できません"
        redirect_to posts_path
      end
    end
end
