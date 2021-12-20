# frozen_string_literal: true

module CustomModule
  # def fill_test_user_info_and_click_button
  #   fill_in 'ニックネーム：', with: "テスト　太郎"
  #   fill_in 'メールアドレス：', with: "test@test.com"
  #   fill_in 'パスワード：', with: "testtest"
  #   fill_in 'パスワード（確認）：', with: "testtest"
  #   click_button '仮登録（メール送信）'
  # end

  def login(user)
    visit login_path
    fill_in 'メールアドレス：', with: user.email
    fill_in 'パスワード：', with: user.password
    click_button 'ログイン'
  end

  # def authenticated?(invitation_token)
  #   BCrypt::Password.new(invitation_digest).is_password?(remember_token)
  # end
end
