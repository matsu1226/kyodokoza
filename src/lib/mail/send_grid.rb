class MailMagazine < ActiveRecord::Base
  require 'sendgrid-ruby'
  include SendGrid

  def self.deliver_mail_magazine
    from = SendGrid::Email.new(email: 'from@example.com')
    to = SendGrid::Email.new(email: 'to@example.com')
    subject = '件名'
    content = SendGrid::Content.new(type: 'text/plain', value: 'テスト配信です')
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end