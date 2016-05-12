假如(/^题目录入员打算修改一道连线题$/) do
  @old_attr = {
    :kind    => 'mapping',
    :content => "我是连线题的题设",
    :mapping_answer => [
      ["北京","中国"],
      ["东京","日本"]
    ],
    :analysis             => "我是连线题题目解析",
    :level                => 1,
    :enabled              => false
  }

  @new_attr = {}
  @question = QuestionBank::Question.create!(@old_attr)
end

假如(/^修改连线题题设内容$/) do
  @new_attr[:content] = "我是连线题的题设修改"
end

假如(/^修改连线题的第一个待连线内容$/) do
  @new_attr[:mapping_answer] = [
    ["首尔","韩国"],
    ["东京","日本"]
  ]
end

假如(/^修改连线题的题目解析内容$/) do
  @new_attr[:analysis] = "我是连线题题目解析修改"
end

假如(/^修改连线题的题目难度系数$/) do
  @new_attr[:level] = 2
end

假如(/^修改连线题的题目发布状态$/) do
  @new_attr[:enabled] = true
end

那么(/^连线题修改成功$/) do
  question = QuestionBank::Question.find(@question.id)
  question.update_attributes(@new_attr)
  question = QuestionBank::Question.find(@question.id)

  expect(question.content).to eq(@new_attr[:content])
  expect(question.mapping_answer).to eq(@new_attr[:mapping_answer])
  expect(question.analysis).to eq(@new_attr[:analysis])
  expect(question.level).to eq(@new_attr[:level])
  expect(question.enabled).to eq(@new_attr[:enabled])
end
