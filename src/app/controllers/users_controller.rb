class UsersController < ApplicationController

  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]


  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)
    @non_activated_user = User.find_by(email: params[:user][:email])

    # 入力したアドレスのユーザーがDBに存在し、activateされていないなら、
    if @non_activated_user && @non_activated_user.activated == false
      if @non_activated_user.update(user_params)
        @user = @non_activated_user 

        @user.send_activation_email
        flash[:info] = "仮登録メールを送信しました。確認してください。"
        redirect_to root_url
      else
        redirect_to new_user_path
        flash[:warning] = "フォームの入力値が不適切です"
      end
    elsif @user.save
      @user.send_activation_email
      flash[:info] = "仮登録メールを送信しました。確認してください。"
      redirect_to root_url
    else
      render action: :new
    end
    
  end

  
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.attributes = { name: params[:user][:name] }
    if @user.save(context: :except_password_change)
    # if @user.update(name: params[:user][:name])
      flash[:success] = "名前を変更しました！"
      redirect_to edit_user_path(@user)
    else
      render "edit"
    end
  end
  # updateのバリデーション => https://hene.dev/blog/2019/06/03/rails-validation

  # def destroy
  #   @user=User.find_by(id: params[:id])
  #   @user.destroy
  #   flash[:danger] = "アカウントを削除しました"
  #   redirect_to root_url
  # end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def user_params_name_only
      params.require(:user).permit(:name)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to user_path(current_user) unless current_user?(@user)
      flash[:warning] = "他のユーザーの情報は見ることができません"
    end

end
