FactoryGirl.define do
  factory :point, class: QuestionBank::Point do
    sequence(:name){|n| "知识点#{n}"}
  end
end

