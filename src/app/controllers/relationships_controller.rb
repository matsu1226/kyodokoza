class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :create_invitation_digest, only: [:invitation_code]
  # before_action :get_user, only: [:new, :create, :invitation_code] 
  before_action :check_no_relationship, only: [:new, :create, :invitation_code]   
  before_action :correct_relationship, only: [:show]
  

  def new
    @relationship = Relationship.new
    # @invitation_token = @user.invitation_token
  end


  def create
    to_user = User.find_by(email: params[:relationship][:email])
    # (1)「相手ユーザーのemailが登録されている」かつ「招待コードが一致」
    @relationship = Relationship.new(name: params[:relationship][:name])

    if to_user.nil?
      flash[:warning] = "そのメールアドレスのユーザーは登録されていません"
      redirect_to new_relationship_path
    elsif !to_user.no_relationship?
      flash[:danger] = "そのパートナーは他の方と家族登録しています"
      redirect_to new_relationship_path
    elsif digest_and_token_is_password?(to_user.invitation_digest, params[:relationship][:invitation_code])
      if @relationship.save
        common_user_password = SecureRandom.urlsafe_base64(10)
        common_user = User.create(name: "共通", 
                                  email: "common_#{current_user.id}@kyodokoza.com", 
                                  password: common_user_password, 
                                  password_confirmation: common_user_password)
        # @relationとcurrent_user/to_user/common_userをつなげる
        current_user.create_user_relationship(relationship_id: @relationship.id)
        to_user.create_user_relationship(relationship_id: @relationship.id)
        common_user.create_user_relationship(relationship_id: @relationship.id)

        flash[:success] = "家族を登録しました"
        redirect_to user_path(current_user)

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
    @relationship = current_user.relationship
    @users = @relationship.users
  end


  def invitation_code
    # @user.create_invitation_digest
  end


  private
    def check_no_relationship
      unless current_user.no_relationship?
        flash[:danger] = "すでに家族が登録されています"
        redirect_to user_path(current_user)
      end
    end


    def create_invitation_digest
      current_user.invitation_token = User.new_token
      # current_user.update(invitation_digest: User.digest(current_user.invitation_token))
      # current_user.update(invitation_made_at: Time.zone.now)
      current_user.attributes = { invitation_digest: User.digest(current_user.invitation_token),
                                  invitation_made_at: Time.zone.now }
      current_user.save(context: :except_password_change)
    end
    
    def correct_relationship
      relationship = Relationship.find_by(id: params[:id])
      unless relationship.users.include?(current_user)
        flash[:danger] = "そのページはあなたの家族ではありません"
        redirect_to login_url
      end
    end

end
