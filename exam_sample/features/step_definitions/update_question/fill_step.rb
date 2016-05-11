假如(/^题目录入员打算修改一道填空题$/) do
  @old_attr = {
    :kind    => 'fill',
    :content => "我是 ___ 填空题 ___ 的题设",
    :fill_answer => ["答案一","答案二"],
    :analysis    => "我是填空题题目解析",
    :level       => 1,
    :enabled     => false
  }

  @new_attr = {}
  @question = QuestionBank::Question.create!(@old_attr)
end

假如(/^修改填空题的待填空的内容$/) do
  @new_attr[:content] = "我是 ___ 填空题 ___ 的题 ___ 设"
end

假如(/^修改填空题的参考答案内容$/) do
  @new_attr[:fill_answer] = ["答案一","答案二","答案三"]
end

假如(/^修改填空题的题目解析内容$/) do
  @new_attr[:analysis] = "我是填空题题目解析修改"
end

假如(/^修改填空题的题目难度系数$/) do
  @new_attr[:level] = 2
end

假如(/^修改填空题的题目发布状态$/) do
  @new_attr[:enabled] = true
end

那么(/^填空题修改成功$/) do
  question = QuestionBank::Question.find(@question.id)
  question.update_attributes(@new_attr)
  question = QuestionBank::Question.find(@question.id)

  expect(question.content).to eq(@new_attr[:content])
  expect(question.fill_answer).to eq(@new_attr[:fill_answer])
  expect(question.analysis).to eq(@new_attr[:analysis])
  expect(question.level).to eq(@new_attr[:level])
  expect(question.enabled).to eq(@new_attr[:enabled])
end
