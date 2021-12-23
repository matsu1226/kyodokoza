# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: '正太郎',
                     email: 'shotaro@kyodokoza.com',
                     password: 'example01',
                     password_confirmation: 'example01')
    ActionMailer::Base.deliveries = []
  end
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:activation_token) }
  it { should respond_to(:activation_digest) }
  it { should respond_to(:reset_digest) }
  it { should respond_to(:relationship) }
  it { should respond_to(:posts) }

  describe '正しいuserを保存するテスト' do
    before { @user.save }
    it { should be_valid }
  end

  context '正しくないuserを保存するテスト' do
    describe '名前が空欄' do
      before { @user.name = ' ' }
      it { should_not be_valid }
    end

    describe '名前が11文字以上' do
      before { @user.name = 'a' * 11 }
      it { should_not be_valid }
    end

    describe 'メールが空欄' do
      before { @user.email = ' ' }
      it { should_not be_valid }
    end

    describe 'メールが重複' do
      let(:user_with_same_email) do
        User.new(name: '健太',
                 email: 'shotaro@kyodokoza.com',
                 password: 'example02',
                 password_confirmation: 'example02')
      end
      before do
        @user.save
        user_with_same_email.save
      end
      it { expect(user_with_same_email).not_to be_valid }
    end

    it 'メールフォーマットがダメ' do
      address = ['examplegmail.com', '@gmail.com', 'example@g_mail.com', 'example@gmailcom', 'example@gmail.56']
      address.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end

    describe 'パスワードが空欄' do
      before { @user.password = ' ' }
      it { should_not be_valid }
    end

    describe 'パスワードが7文字以下' do
      before do
        @user.password = 'example'
        @user.password_confirmation = 'example'
      end
      it { should_not be_valid }
    end

    describe 'パスワードが20文字以上' do
      before do
        @user.password = 'example01example01example01'
        @user.password_confirmation = 'example01example01example01'
      end
      it { should_not be_valid }
    end
  end

  describe 'コールバックのテスト' do
    describe 'before_create :create_activation_digest のテスト' do
      it { expect { @user.save }.to change { @user.activation_token }.from(nil).to(String) }
      it { expect { @user.save }.to change { @user.activation_digest }.from(nil).to(String) }
    end
  end

  describe 'メソッドのテスト' do
    before { @user.save }

    describe 'authenticated?のテスト' do
      let(:user_activation_token) { @user.activation_token }
      it { expect(@user.authenticated?(:activation, user_activation_token)).to eq true }
    end

    describe 'send_activation_emailのテスト' do
      it { expect { @user.send_activation_email }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    end

    describe 'authenticateのテスト' do
      let(:found_user) { User.find_by(email: @user.email) }

      describe '正しいパスワード' do
        it { should eq found_user.authenticate(@user.password) }
      end

      describe '間違ったパスワード' do
        let(:user_with_invalid_password) { found_user.authenticate('invalid') }
        it { should_not eq user_with_invalid_password }
        it { expect(user_with_invalid_password).to be false }
      end
    end

    describe 'activateのテスト' do
      # before { @user.activate }
      # it { expect(@user.activated).to eq true }
      it { expect { @user.activate }.to change { @user.activated }.from(false).to(true) }
    end

    describe 'create_reset_digestのテスト' do
      it { expect { @user.create_reset_digest }.to change { @user.reset_token }.from(nil).to(String) }
      it { expect { @user.create_reset_digest }.to change { @user.reset_digest }.from(nil).to(String) }
    end

    describe 'send_password_reset_emailのテスト' do
      it 'send_password_reset_emailのテスト' do
        expect do
          @user.create_reset_digest
          @user.send_password_reset_email
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    describe 'password_reset_expired? のテスト' do
      describe '2時間以内' do
        before do
          @user.create_reset_digest
          @user.update(reset_sent_at: 1.hour.ago)
        end
        it { expect(@user.password_reset_expired?).to be_falsy }
      end

      describe '2時間以上' do
        before do
          @user.create_reset_digest
          @user.update(reset_sent_at: 1.day.ago)
        end
        it { expect(@user.password_reset_expired?).to be_truthy }
      end
    end

    describe 'create_invitation_digestのテスト' do
      it { expect { @user.create_invitation_digest }.to change { @user.invitation_token }.from(nil).to(String) }
      it { expect { @user.create_invitation_digest }.to change { @user.invitation_digest }.from(nil).to(String) }
    end

    describe 'no_relationship?　のテスト' do
      it 'relationship なし' do
        expect(@user.no_relationship?).to be true
      end

      it 'relationshipが存在' do
        expect do
          Relationship.create(id: 2, name: '山田家')
          @user.create_user_relationship(relationship_id: 2)
        end.to change { Relationship.count }.by(1)
        expect(@user.no_relationship?).to be false
      end
    end

    describe 'rememberのテスト' do
      it { expect { @user.remember }.to change { @user.remember_digest }.from(nil).to(String) }
    end

    describe 'forgetのテスト' do
      before { @user.update(remember_digest: 'hogehoge') }
      it { expect { @user.forget }.to change { @user.remember_digest }.from(String).to(nil) }
    end

    describe 'create_common_userのテスト' do
      before { @user.create_common_user }
      it { expect(User.find_by(email: "common_#{@user.id}@kyodokoza.com")).to be_present }
    end
  end
end
