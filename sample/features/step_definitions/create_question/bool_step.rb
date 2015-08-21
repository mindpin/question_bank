假如(/^题目录入员打算把一道判断题录入到题库中$/) do
  @input = {}

  @bool_attrs = {:kind => 'bool'}
end

假如(/^给判断题录入一项有待做出是非判断的内容$/) do
  @input[:content] = "我是判断题的题设"

  @bool_attrs[:content] = @input[:content]
end

假如(/^给判断题录入参考答案，是或非$/) do
  @input[:bool_answer] = true

  @bool_attrs[:bool_answer] = @input[:bool_answer]
end

假如(/^给判断题录入题目解析$/) do
  @input[:analysis] = "我是判断题题目解析"

  @bool_attrs[:analysis] = @input[:analysis]
end

假如(/^给判断题录入难度系数$/) do
  @input[:level] = 1

  @bool_attrs[:level] = @input[:level]
end

假如(/^给判断题录入发布状态$/) do
  @input[:enabled] = false

  @bool_attrs[:enabled] = @input[:enabled]
end

假如(/^保存判断题的所有录入$/) do
  @question = QuestionBank::Question.create(@bool_attrs)
end

那么(/^判断题录入成功$/) do
  expect(@question.new_record?).to eq(false)
  expect(@question.valid?).to eq(true)

  expect(QuestionBank::Question.bool.count).to eq(1)

  question = QuestionBank::Question.where(:id => @question.id).first

  expect(question.content).to eq(@input[:content])

  expect(question.bool_answer).to eq(@input[:bool_answer])

  expect(question.analysis).to eq(@input[:analysis])
  expect(question.level).to eq(@input[:level])
  expect(question.enabled).to eq(@input[:enabled])

end
