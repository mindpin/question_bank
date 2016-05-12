FactoryGirl.define do
  factory :demo_question do
    kind :qanda
    sequence(:content){|n| "问答题题#{n}"}
    enabled true
    level 1
    answer { self.content }
    subject "chinese"
  end
end

