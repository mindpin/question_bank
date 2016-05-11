假如(/^题目录入员打算删除一道题目$/) do
  @attr = {
    :kind    => 'single_choice',
    :content => "我是单选题的题设",
    :choices => [
      "我是单选题待选项一",
      "我是单选题待选项二"
    ],
    :choice_answer_indexs => [0],
    :analysis             => "我是单选题题目解析",
    :level                => 1,
    :enabled              => false
  }

  @question = QuestionBank::Question.create!(@attr)
end

假如(/^对题目发起删除请求$/) do
  question = QuestionBank::Question.find(@question.id)
  question.destroy
end

假如(/^题目删除成功$/) do
  expect(QuestionBank::Question.where(:id => @question.id).count).to eq(0)
end
