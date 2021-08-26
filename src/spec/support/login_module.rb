module LoginModule
  def login(user)
    visit login_path
    fill_in 'メールアドレス：', with: "qqq.ms1126@gmail.com"
    fill_in 'パスワード：', with: "example01"
    click_button 'ログイン'
  end
end