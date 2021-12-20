# frozen_string_literal: true

FactoryBot.define do
  # 正太郎と松田家
  factory :user_relationship do
    user
    relationship
  end

  # # 綾美と松田家
  # factory :user_relationship2, class:"UserRelationship" do
  #   user_id { 2 }
  #   relationship_id { 1 }
  # end

  # # 健太と松田家
  # factory :user_relationship3, class:"UserRelationship" do
  #   user_id { 3 }
  #   relationship_id { 2 }
  # end

  # # 由美と松田家
  # factory :user_relationship4, class:"UserRelationship" do
  #   user_id { 4 }
  #   relationship_id { 2 }
  # end

  # # other_userと松田家
  #   factory :user_relationship5, class:"UserRelationship" do
  #     user_id { 5 }
  #     relationship_id { 3 }
  #   end
end
