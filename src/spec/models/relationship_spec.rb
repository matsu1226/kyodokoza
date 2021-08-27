require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:from_user) { FactoryBot.create(:user) }
  let!(:to_user) { FactoryBot.create(:other_user) }
  let(:relationship) { from_user.active_relationships.build(name: "松田家", to_user_id: to_user.id) }

  subject { relationship }

  it { should be_valid }

  it { should respond_to(:to_user) }
  it { should respond_to(:from_user) }
  it { expect(relationship.from_user).to eq from_user }
  it { expect(relationship.to_user).to eq to_user }

  context "バリデーション" do
    describe "from_user_idはpresence true" do
      before { relationship.from_user_id = nil }
      it { should_not be_valid }
    end

    describe "to_user_idはpresence true" do
      before { relationship.to_user_id = nil }
      it { should_not be_valid }
    end

    describe "名前はpresence true" do
      before { relationship.name = nil }
      it { should_not be_valid }
    end

    describe "" do
      let!(:third_user) { }
      before { from_user.active_relationships.build(name: "山田家", to_user_id: third_user.id) }
      it { should_not be_valid }
    end
  end
end
