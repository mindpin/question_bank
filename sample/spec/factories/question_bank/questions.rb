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



  #
  factory :single_choice_question_wugui, class: QuestionBank::Question do
    kind "single_choice"
    content "乌龟有几条腿"
    choice_answer [["一条", false], ["两条", false], ["三条", false], ["四条", true]]
    level 1
    enabled true
  end
  #
  factory :multi_choice_question_xiaochao, class: QuestionBank::Question do
    kind "multi_choice"
    content "小超有几条腿"
    choice_answer [["一条", false], ["两条", true], ["三条", true], ["四条", true], ["五条", true]]
    level 1
    enabled true
  end

  factory :fill_question_say_hello, class: QuestionBank::Question do
    kind "fill"
    content "中国___, 英国___"
    fill_answer ["北京", "伦敦"]
    level 1
    enabled true
  end
end
