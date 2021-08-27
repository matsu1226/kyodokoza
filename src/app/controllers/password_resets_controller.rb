class PasswordResetsController < ApplicationController
  # require "pry"

  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      # binding.pry
      flash[:info] = "パスワード変更メールを送信しました"
      redirect_to root_url
    else
      flash.now[:danger] = "入力されたアドレスは登録されていません"
      render action: :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = "パスワードが更新されました"
      redirect_to user_path(@user)
    else
      render 'edit'
    end

  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        message = "パスワード変更メールが期限切れです"
        message += "もう一度メールを送信してください"
        flash[:danger] = message
        redirect_to new_password_reset_url
      end
    end

end
