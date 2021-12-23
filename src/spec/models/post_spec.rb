# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }

  before do
    # relationship = Relationship.find_by(name: "松田家")
    @post = Post.new(user_id: user.id,
                     category_id: food_expenses.id,
                     content: 'たいらや_食材',
                     payment_at: Time.zone.local(2021, 8, 31, 12, 0o0, 0o0),
                     price: 1200)
  end

  subject { @post }

  it '正しいpostを保存するテスト' do
    @post.save
    should be_valid
  end

  it { should respond_to(:content) }
  it { should respond_to(:price) }
  it { should respond_to(:category_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:payment_at) }
  it { should respond_to(:category) }
  it { should respond_to(:user) }

  it 'contentが空欄' do
    @post.content = ''
    should_not be_valid
  end

  it 'contentが31文字以上' do
    @post.content = 'a' * 31
    should_not be_valid
  end

  it 'priceが空欄' do
    @post.price = ''
    should_not be_valid
  end

  it 'priceがマイナス' do
    @post.price = -1
    should_not be_valid
  end

  it 'user_idが空欄' do
    @post.user_id = ''
    should_not be_valid
  end

  it 'category_idが空欄' do
    @post.category_id = ''
    should_not be_valid
  end

  it 'payment_atが空欄' do
    @post.payment_at = ''
    should_not be_valid
  end
end
