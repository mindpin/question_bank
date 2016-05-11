假如(/^题目录入员打算把一道连线题录入到题库中$/) do
  @input = {}

  @mapping_attrs = {:kind => 'mapping'}
end

假如(/^给连线题录入题设$/) do
  @input[:content] = "我是连线题的题设"

  @mapping_attrs[:content] = @input[:content]
end

假如(/^给连线题录入两对连线内容$/) do
  @input[:mapping_answer] = [
    ["北京","中国"],
    ["东京","日本"]
  ]

  @mapping_attrs[:mapping_answer] = @input[:mapping_answer]
end

假如(/^给连线题录入题目解析$/) do
  @input[:analysis] = "我是连线题题目解析"

  @mapping_attrs[:analysis] = @input[:analysis]
end

假如(/^给连线题录入难度系数$/) do
  @input[:level] = 1

  @mapping_attrs[:level] = @input[:level]
end

假如(/^给连线题录入发布状态$/) do
  @input[:enabled] = false

  @mapping_attrs[:enabled] = @input[:enabled]
end

假如(/^保存连线题的所有录入$/) do
  @question = QuestionBank::Question.create(@mapping_attrs)
end

那么(/^连线题录入成功$/) do
  expect(@question.new_record?).to eq(false)
  expect(@question.valid?).to eq(true)

  expect(QuestionBank::Question.mapping.count).to eq(1)

  question = QuestionBank::Question.where(:id => @question.id).first

  expect(question.content).to eq(@input[:content])

  expect(question.mapping_answer).to eq(@input[:mapping_answer])

  expect(question.analysis).to eq(@input[:analysis])
  expect(question.level).to eq(@input[:level])
  expect(question.enabled).to eq(@input[:enabled])
end



假如(/^给连线题录入一对连线内容$/) do
  @input[:mapping_answer] = [
    ["北京","中国"]
  ]

  @mapping_attrs[:mapping_answer] = @input[:mapping_answer]
end

那么(/^连线题录入失败$/) do
  expect(@question.new_record?).to eq(true)
  expect(@question.valid?).to eq(false)
  expect(QuestionBank::Question.mapping.count).to eq(0)

  question = QuestionBank::Question.where(:id => @question.id).first
  expect(question.class).to eq(NilClass)
end
