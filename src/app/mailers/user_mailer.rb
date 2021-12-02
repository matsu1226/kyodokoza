class UserMailer < ApplicationMailer
  helper StatsHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "仮登録（家計簿アプリ「キョウドウコウザ」）"
  end
  
  def weekly_notification
    attachments.inline['kawauso.png'] = File.read('app/assets/images/kawauso.png')
    @this_month_days = Time.days_in_month(Time.zone.now.month, Time.zone.now.year)
    Relationship.all.each do |relationship|
      @relationship = relationship
      @user1 = @relationship.users[0]
      @user2 = @relationship.users[1]
      mail  to:       @user1.email,
            cc:       @user2.email,
            subject:  "うそうそくんからのお手紙(#{l Time.zone.now.prev_week(:monday), format: :short_date} ~ #{l Time.zone.now.prev_week(:sunday), format: :short_date}）/ 家計簿アプリ「キョウドウコウザ」"
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワード変更（家計簿アプリ「キョウドウコウザ」）"
  end
end
