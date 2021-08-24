class UsersController < ApplicationController
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
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
