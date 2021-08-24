require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }
    let(:mail_body) { mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join }
    # Base64 encodeをデコードして比較できるようにする
    # https://easyramble.com/test-action-mailer-with-rspec.html

    it "renders the headers" do
      expect(mail.subject).to eq("仮登録（家計簿アプリ「キョウドウコウザ」）")
      expect(mail.to).to eq(["qqq.ms1126@gmail.com"])
      expect(mail.from).to eq(["noreply@kyodokoza.com"])
    end

    it "renders the body" do
      expect(mail_body).to match CGI.escape("kyodokoza.herokuapp.com")
    end
  end

  # describe "password_reset" do
  #   let(:mail) { UserMailer.password_reset }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

end
