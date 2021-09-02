class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :get_user
  before_action :create_invitation_digest, only: [:invitation_code]
  before_action :check_no_relationship, only: [:new, :create, :invitation_code]   #  (0)「自分が誰とも家族登録されていない」
  

  def new
    @relationship = Relationship.new
    # @invitation_token = @user.invitation_token
  end


  def create
    @to_user = User.find_by(email: params[:relationship][:email])
    # (1)「相手ユーザーのemailが登録されている」かつ「招待コードが一致」
    @relationship = Relationship.new(name: params[:relationship][:name])

    if @to_user.nil?
      flash[:warning] = "そのメールアドレスのユーザーは登録されていません"
      redirect_to new_relationship_path
    elsif !@to_user.no_relationship?
      flash[:danger] = "パートナーが既に他の方と家族登録しています"
      redirect_to new_relationship_path
    elsif BCrypt::Password.new(@to_user.invitation_digest).is_password?(params[:relationship][:invitation_code])
      if @relationship.save
        @user.create_user_relationship(relationship_id: @relationship.id)
        @to_user.create_user_relationship(relationship_id: @relationship.id)
        flash[:success] = "家族を登録しました"
      else
        flash[:warning] = "家族の名前の文字数を確認してください"
        redirect_to new_relationship_path    
      end
    else
      flash[:warning] = "招待コードが間違っています"
      redirect_to new_relationship_path
    end
  end


  def show
    @relationship = @user.relationship
    @users = @relationship.users
  end


  def invitation_code
    # @user.create_invitation_digest
  end


  private
    def get_user
      @user = User.find_by(id: current_user.id)
    end

    def check_no_relationship
      unless @user.no_relationship?
        flash[:danger] = "すでに家族が登録されています"
        redirect_to user_path(@user)
      end
    end

    def create_invitation_digest
      @user.invitation_token = User.new_token
      @user.update(invitation_digest: User.digest(@user.invitation_token))
      @user.update(invitation_made_at: Time.zone.now)
    end

end
