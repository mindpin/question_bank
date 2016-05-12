FactoryGirl.define do
  factory :test_paper, class: QuestionBank::TestPaper do
    sequence(:title){|n| "试卷#{n}"}
    score 100
    minutes 60
  end
end
