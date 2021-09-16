class StaticPagesController < ApplicationController
  def introduction
  end

  # def gest_sign_in
  #   user = User.find_or_create_by!(email: 'guest@example.com') do |user|
  #     user.name = "ゲストユーザー"
  #     user_password = SecureRandom.urlsafe_base64(10)
  #     user.password_digest = user.digest(user_password)
  #     user.activate
  #     set_invitation_digest
  #   end
  #   log_in user

  #   user2 = User.find_or_create_by!(email: 'guest2@example.com') do |user2|
  #     user2.name = "ゲストユーザー"
  #     user2_password = SecureRandom.urlsafe_base64(10)
  #     user2.password_digest = user2.digest(user2_password)
  #     user2.activate
  #     set_invitation_digest
  #   end
  #   log_in user2

  #   redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  # end
end
