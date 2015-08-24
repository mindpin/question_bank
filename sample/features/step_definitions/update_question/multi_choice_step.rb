假如(/^题目录入员打算修改一道多选题$/) do
  @old_attr = {
    :kind    => 'multi_choice',
    :content => "我是多选题的题设",
    :choices => [
      "我是多选题待选项一",
      "我是多选题待选项二",
      "我是多选题待选项三",
    ],
    :choice_answer_indexs => [0,1],
    :analysis             => "我是多选题题目解析",
    :level                => 1,
    :enabled              => false
  }

  @new_attr = {}
  @question = QuestionBank::Question.create!(@old_attr)
end

假如(/^修改多选题的题设内容$/) do
  @new_attr[:content] = "我是多选题的题设修改"
end

假如(/^修改多选题的选项内容$/) do
  @new_attr[:choices] = [
    "我是多选题待选项一修改",
    "我是多选题待选项二",
    "我是多选题待选项三",
  ]
end

假如(/^修改多选题的参考答案内容$/) do
  @new_attr[:choice_answer_indexs] = [1,2]
end

假如(/^修改多选题的题目解析内容$/) do
  @new_attr[:analysis] = "我是多选题题目解析修改"
end

假如(/^修改多选题的题目难度系数$/) do
  @new_attr[:level] = 3
end

假如(/^修改多选题的题目发布状态$/) do
  @new_attr[:enabled] = true
end

那么(/^多选题修改成功$/) do
  question = QuestionBank::Question.find(@question.id)
  question.update_attributes(@new_attr)
  question = QuestionBank::Question.find(@question.id)

  expect(question.content).to eq(@new_attr[:content])
  expect(question.choices).to eq(@new_attr[:choices])
  expect(question.choice_answer_indexs).to eq(@new_attr[:choice_answer_indexs])
  expect(question.analysis).to eq(@new_attr[:analysis])
  expect(question.level).to eq(@new_attr[:level])
  expect(question.enabled).to eq(@new_attr[:enabled])
end
