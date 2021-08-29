class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :get_user
  before_action :create_invitation_digest, only: [:invitation_code]
  

  def new
    @relationship = Relationship.new
    # @invitation_token = @user.invitation_token
  end


  def create
    @to_user = User.find_by(invitation_digest: params[:relationship][:invitation_code])
    # 加えて、to_user, from_userのuniquenessもifではじきたい。
    if @to_user 
      @user.create_active_relationships(name: params[:relationship][:name], to_user_id: @to_user)
      @to_user.create_active_relationships(name: params[:relationship][:name], to_user_id: @user)
      flash[:success] = "家族を登録しました"
      redirect_to relationship_path(@user.active_relationships)
    else
      flash[:warning] = "招待コードが間違っています"
      render "new"
    end
  end


  def show
  end


  def invitation_code
    # @user.create_invitation_digest
  end


  private
    def get_user
      @user = User.find_by(id: current_user.id)
    end

    # def create_invitation_digest
    #   @user.invitation_token = User.new_token
    #   @user.invitation_digest = User.digest(@user.invitation_token)
    #   @user.invitation_made_at = Time.zone.now
    # end

    def create_invitation_digest
      @user.invitation_token = User.new_token
      @user.update(invitation_digest: User.digest(@user.invitation_token))
      @user.update(invitation_made_at: Time.zone.now)
    end

end
