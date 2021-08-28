require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:from_user) { FactoryBot.create(:user) }
  let!(:to_user) { FactoryBot.create(:user2) }
  let(:active_relationship) { from_user.build_active_relationships(name: "松田家", to_user_id: to_user.id) }
  let(:passive_relationship) { to_user.build_active_relationships(name: "松田家", to_user_id: from_user.id) }

  subject { active_relationship }

  it { should be_valid }

  it { should respond_to(:to_user) }
  it { should respond_to(:from_user) }
  it { expect(active_relationship.from_user).to eq from_user }
  it { expect(active_relationship.to_user).to eq to_user }


  context "バリデーション" do
    describe "from_user_idはpresence true" do
      before { active_relationship.from_user_id = nil }
      it { should_not be_valid }
    end

    describe "to_user_idはpresence true" do
      before { active_relationship.to_user_id = nil }
      it { should_not be_valid }
    end

    describe "名前はpresence true" do
      before { active_relationship.name = nil }
      it { should_not be_valid }
    end

    # => relationship.rbのvalidationメソッドにて定義!
    
    # describe "from_user_idはuniqueness true" do   
    #   let!(:other_user) { FactoryBot.create(:other_user) }
    #   let(:other_active_relationship) { from_user.build_active_relationships(name: "山田家", to_user_id: other_user.id) }
    #   before do
    #     active_relationship.save
    #     other_active_relationship.save
    #   end
    #   it { expect(other_active_relationship).not_to be_valid }
    # end
  end
end
