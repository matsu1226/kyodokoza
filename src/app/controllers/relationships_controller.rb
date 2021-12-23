class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :create_invitation_digest, only: [:invitation_code]
  before_action :check_no_relationship, only: %i[new create invitation_code]

  def new
    @relationship = Relationship.new
    # @invitation_token = @user.invitation_token
  end

  def create
    to_user = User.find_by(email: params[:relationship][:email])
    # (1)「相手ユーザーのemailが登録されている」かつ「招待コードが一致」
    @relationship = Relationship.new(name: params[:relationship][:name])

    if to_user.nil?
      flash[:warning] = 'そのメールアドレスのユーザーは登録されていません'
      redirect_to new_relationship_path
    elsif !to_user.no_relationship?
      flash[:danger] = 'そのパートナーは他の方と家族登録しています'
      redirect_to new_relationship_path
    elsif digest_and_token_is_password?(to_user.invitation_digest, params[:relationship][:invitation_code])
      if @relationship.save
        common_user = current_user.create_common_user
        [current_user, to_user, common_user].each do |u|
          u.create_user_relationship(relationship_id: @relationship.id)
        end
        flash[:success] = '家族を登録しました'
        redirect_to user_path(current_user)
      else
        flash[:warning] = '家族の名前の文字数を確認してください'
        redirect_to new_relationship_path
      end
    else
      flash[:warning] = '招待コードが間違っています'
      redirect_to new_relationship_path
    end
  end

  def invitation_code; end

  private

  def check_no_relationship
    return if current_user.no_relationship?

    flash[:danger] = 'すでに家族が登録されています'
    redirect_to user_path(current_user)
  end

  def create_invitation_digest
    current_user.invitation_token = User.new_token
    # current_user.update(invitation_digest: User.digest(current_user.invitation_token))
    # current_user.update(invitation_made_at: Time.zone.now)
    current_user.attributes = { invitation_digest: User.digest(current_user.invitation_token),
                                invitation_made_at: Time.zone.now }
    current_user.save(context: :except_password_change)
  end
end
