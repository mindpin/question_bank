FactoryGirl.define do
  factory :question, class: QuestionBank::Question do
    kind :single_choice
    sequence(:content){|n| "单选题#{n}"}
    enabled true
    level 2
    choice_answer [["答案1", true], ["答案2", false]]
  end

  factory :bool_question, class: QuestionBank::Question do
    kind :bool
    content "一加一等于二"
    enabled true
    level 1
    bool_answer true
  end
end
