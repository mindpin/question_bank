假如(/^题目录入员打算把一道论述题录入到题库中$/) do
  @input = {}

  @essay_attrs = {:kind => 'essay'}
end

假如(/^给论述题录入题设$/) do
  @input[:content] = "我是论述题的题设"

  @essay_attrs[:content] = @input[:content]
end

假如(/^给论述题录入参考答案$/) do
  @input[:essay_answer] = "我是论述题的参考答案"

  @essay_attrs[:essay_answer] = @input[:essay_answer]
end

假如(/^给论述题录入题目解析$/) do
  @input[:analysis] = "我是论述题题目解析"

  @essay_attrs[:analysis] = @input[:analysis]
end

假如(/^给论述题录入难度系数$/) do
  @input[:level] = 1

  @essay_attrs[:level] = @input[:level]
end

假如(/^给论述题录入发布状态$/) do
  @input[:enabled] = false

  @essay_attrs[:enabled] = @input[:enabled]
end

假如(/^保存论述题的所有录入$/) do
  @question = QuestionBank::Question.create(@essay_attrs)
end

那么(/^论述题录入成功$/) do
  expect(@question.new_record?).to eq(false)
  expect(@question.valid?).to eq(true)

  expect(QuestionBank::Question.essay.count).to eq(1)

  question = QuestionBank::Question.where(:id => @question.id).first

  expect(question.content).to eq(@input[:content])

  expect(question.essay_answer).to eq(@input[:essay_answer])

  expect(question.analysis).to eq(@input[:analysis])
  expect(question.level).to eq(@input[:level])
  expect(question.enabled).to eq(@input[:enabled])
end
