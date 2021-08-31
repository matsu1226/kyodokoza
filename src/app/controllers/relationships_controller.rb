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
    if @to_user && BCrypt::Password.new(@to_user.invitation_digest).is_password?(params[:relationship][:invitation_code])
      active_relationship = Relationship.new(name: params[:relationship][:name], from_user_id: @user.id, to_user_id: @to_user.id)
      passive_relationship = Relationship.new(name: params[:relationship][:name], from_user_id: @to_user.id, to_user_id: @user.id)
      # (1-1)「家族名の文字数がvalidation内」
      if (active_relationship.save && passive_relationship.save)    
        flash[:success] = "家族を登録しました"
        redirect_to relationship_path(@user.active_relationships)
      # (1-2)「家族名の文字数error」
      else  
        flash[:warning] = "家族の名前の文字数を確認してください"
        redirect_to new_relationship_path    
      end
    # (2)「相手ユーザーのemailが登録されている」けど「招待コードが一致していない」
    elsif @to_user  
      flash[:warning] = "招待コードが間違っています"
      redirect_to new_relationship_path
    # (3)「相手ユーザーのemailが登録されていない」
    else  
      flash[:warning] = "そのメールアドレスのユーザーは登録されていません"
      redirect_to new_relationship_path
    end
  end

  def show
    @relationship = @user.active_relationships
  end


  def invitation_code
    # @user.create_invitation_digest
  end


  private
    def get_user
      @user = User.find_by(id: current_user.id)
    end

    def create_invitation_digest
      @user.invitation_token = User.new_token
      @user.update(invitation_digest: User.digest(@user.invitation_token))
      @user.update(invitation_made_at: Time.zone.now)
    end

    def check_no_relationship
      unless @user.no_relationship?
        flash[:danger] = "すでに家族が登録されています"
        redirect_to user_path(@user)
      end
    end

end
