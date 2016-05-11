假如(/^题目录入员打算修改一道论述题$/) do
  @old_attr = {
    :kind    => 'essay',
    :content => "我是论述题的题设",
    :essay_answer => "我是论述题的参考答案",
    :analysis     => "我是论述题题目解析",
    :level        => 1,
    :enabled      => false
  }

  @new_attr = {}
  @question = QuestionBank::Question.create!(@old_attr)
end

假如(/^修改论述题的题设内容$/) do
  @new_attr[:content] = "我是论述题的题设修改"
end

假如(/^修改论述题的参考答案内容$/) do
  @new_attr[:essay_answer] = "我是论述题的参考答案修改"
end

假如(/^修改论述题的题目解析内容$/) do
  @new_attr[:analysis] = "我是论述题题目解析修改"
end

假如(/^修改论述题的题目难度系数$/) do
  @new_attr[:level] = 2
end

假如(/^修改论述题的题目发布状态$/) do
  @new_attr[:enabled] = true
end

那么(/^论述题修改成功$/) do
  question = QuestionBank::Question.find(@question.id)
  question.update_attributes(@new_attr)
  question = QuestionBank::Question.find(@question.id)

  expect(question.content).to eq(@new_attr[:content])
  expect(question.essay_answer).to eq(@new_attr[:essay_answer])
  expect(question.analysis).to eq(@new_attr[:analysis])
  expect(question.level).to eq(@new_attr[:level])
  expect(question.enabled).to eq(@new_attr[:enabled])
end
