FactoryGirl.define do
  factory :section, class: QuestionBank::Section do
    kind :single_choice
    score 5
    min_level 1
    max_level 10
  end
end
