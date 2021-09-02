class UsersController < ApplicationController

  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]


  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "仮登録メールを送信しました。メールを確認して登録を完了させてください。"
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
    if @user.update(user_params_name_only)
      flash[:success] = "名前を変更しました！"
      redirect_to edit_user_path(@user)
    else
      render "edit"
    end
  end

  def destroy
    @user=User.find_by(id: params[:id])
    @user.destroy
    flash[:danger] = "アカウントを削除しました"
    redirect_to root_url
  end


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
    end

end
