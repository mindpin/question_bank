FactoryGirl.define do
  factory :question, class: QuestionBank::Question do
    kind :single_choice
    sequence(:content){|n| "单选题#{n}"}
    enabled true
    level 2
    choice_answer [["答案1", true], ["答案2", false]]
  end
end
