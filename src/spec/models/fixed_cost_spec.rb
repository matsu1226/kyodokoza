# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FixedCost, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:relationship) { FactoryBot.create(:relationship) }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  let!(:fixed_cost) { FactoryBot.create(:fixed_cost, relationship: relationship) }

  before do
    @fixed_cost = FixedCost.new(user_id: user.id,
                                category_id: fixed_cost.id,
                                content: '家賃',
                                payment_date: 27,
                                price: 75_000)
  end

  subject { @fixed_cost }

  it { should respond_to(:content) }
  it { should respond_to(:price) }
  it { should respond_to(:category_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:payment_date) }
  it { should respond_to(:category) }
  it { should respond_to(:user) }

  it '正しいfixed_costを保存するテスト' do
    @fixed_cost.save
    should be_valid
  end

  it 'contentが空欄' do
    @fixed_cost.content = ''
    should_not be_valid
  end

  it 'contentが31文字以上' do
    @fixed_cost.content = 'a' * 31
    should_not be_valid
  end

  it 'priceが空欄' do
    @fixed_cost.price = ''
    should_not be_valid
  end

  it 'priceがマイナス' do
    @fixed_cost.price = -1
    should_not be_valid
  end

  it 'user_idが空欄' do
    @fixed_cost.user_id = ''
    should_not be_valid
  end

  it 'category_idが空欄' do
    @fixed_cost.category_id = ''
    should_not be_valid
  end

  it 'payment_dateが空欄' do
    @fixed_cost.payment_date = ''
    should_not be_valid
  end

  it 'payment_dateが0以下' do
    @fixed_cost.payment_date = 0
    should_not be_valid
  end

  it 'payment_dateが31以上' do
    @fixed_cost.payment_date = 32
    should_not be_valid
  end
end
