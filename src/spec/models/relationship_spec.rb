require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user2) }
  let!(:relationship) { Relationship.create(id: 1, name: "松田家") }

  before do
    user.create_user_relationship(relationship_id: 1)          
    user2.create_user_relationship(relationship_id: 1)          
  end

  subject { relationship }

  it { should be_valid }

  it { should respond_to(:users) }
  it { should respond_to(:user_relationships) }
  it { should respond_to(:categories) }
  it { should respond_to(:posts) }
  it { should respond_to(:name) }
  it { expect(relationship.users).to contain_exactly(user, user2) }



  context "バリデーション" do
    describe "名前はpresence true" do
      before { relationship.name = nil }
      it { should_not be_valid }
    end
  end
end
