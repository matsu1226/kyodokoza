require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user2) }
  let!(:relationship) { Relationship.create(id: 1, name: "松田家") }

  before do
    user.create_user_relationship(relationship_id: 1)          
    user2.create_user_relationship(relationship_id: 1)          
    @category = Category.new(name: "食費",
                            color: "#00f",
                            content: "スーパー、外食、買い食いなど",
                            target_price: 36000,
                            relationship_id: relationship.id)
  end

  subject { @category }

  it "正しい保存" do
    @category.save
    should be_valid
  end

  it { should respond_to(:name) }
  it { should respond_to(:content) }
  it { should respond_to(:color) }
  it { should respond_to(:target_price) }
  it { should respond_to(:relationship) }
  it { should respond_to(:posts) }

  it "名前が空欄" do
    @category.name = ""
    should_not be_valid
  end

  it "名前が9文字以上" do
    @category.name = "１２３４５６７８９"
    should_not be_valid
  end

  it "relationship_idが空欄" do
    @category.relationship_id = ""
    should_not be_valid
  end

  it "target_priceが空欄" do
    @category.target_price = ""
    should_not be_valid
  end

end
