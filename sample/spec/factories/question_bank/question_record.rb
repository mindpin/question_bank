# FactoryGirl.define do
#   factory :question_record, class: QuestionBank::QuestionRecord do
#     kind :single_choice
#     sequence(:content){|n| "单选题#{n}"}
#     enabled true
#     level 2
#     choice_answer [["答案1", true], ["答案2", false]]
#   end

#   factory :questions, class: QuestionBank::Question do
#     id             "2354879564145235"
#     bool_answer    nil
#     choice_answer  [["一条", false], ["两条", false], ["三条", false], ["四条", true]]
#     essay_answer   ""
#     fill_answer    nil
#     mapping_answer nil
#     content        "乌龟有几条腿"
#     analysis       nil
#     level          1
#     enabled        true
#   end
# end