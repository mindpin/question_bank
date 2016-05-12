假如(/^题目录入员打算修改一道判断题$/) do
  @old_attr = {
    :kind    => 'bool',
    :content => "我是判断题的题设",
    :bool_answer => true,
    :analysis    => "我是判断题题目解析",
    :level       => 1,
    :enabled     => false
  }

  @new_attr = {}
  @question = QuestionBank::Question.create!(@old_attr)
end

假如(/^修改判断题的待判断内容$/) do
  @new_attr[:content] = "我是判断题的题设修改"
end

假如(/^修改判断题的题目解析内容$/) do
  @new_attr[:analysis] = "我是判断题题目解析"
end

假如(/^修改判断题的参考答案内容$/) do
  @new_attr[:bool_answer] = false
end

假如(/^修改判断题的题目难度系数$/) do
  @new_attr[:level] = 2
end

假如(/^修改判断题的题目发布状态$/) do
  @new_attr[:enabled] = true
end

那么(/^判断题修改成功$/) do
  question = QuestionBank::Question.find(@question.id)
  question.update_attributes(@new_attr)
  question = QuestionBank::Question.find(@question.id)

  expect(question.content).to eq(@new_attr[:content])
  expect(question.bool_answer).to eq(@new_attr[:bool_answer])
  expect(question.analysis).to eq(@new_attr[:analysis])
  expect(question.level).to eq(@new_attr[:level])
  expect(question.enabled).to eq(@new_attr[:enabled])
end
