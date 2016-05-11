假如(/^题目录入员打算把一道填空题录入到题库中$/) do
  @input = {}

  @fill_attrs = {:kind => 'fill'}
end

假如(/^给填空题录入一项待填空的内容，在内容中标记出两个位置需要填充。$/) do
  # 如果题设中出现了 " ___ " 字符串，就把其看作一个填空
  @input[:content] = "我是 ___ 填空题 ___ 的题设"

  @fill_attrs[:content] = @input[:content]
end

假如(/^给填空题录入两个位置的参考答案$/) do
  @input[:fill_answer] = ["答案一","答案二"]

  @fill_attrs[:fill_answer] = @input[:fill_answer]
end

假如(/^给填空题录入题目解析$/) do
  @input[:analysis] = "我是填空题题目解析"

  @fill_attrs[:analysis] = @input[:analysis]
end

假如(/^给填空题录入难度系数$/) do
  @input[:level] = 1

  @fill_attrs[:level] = @input[:level]
end

假如(/^给填空题录入发布状态$/) do
  @input[:enabled] = false

  @fill_attrs[:enabled] = @input[:enabled]
end

假如(/^保存填空题的所有录入$/) do
  @question = QuestionBank::Question.create(@fill_attrs)
end

那么(/^填空题录入成功$/) do
  expect(@question.new_record?).to eq(false)
  expect(@question.valid?).to eq(true)

  expect(QuestionBank::Question.fill.count).to eq(1)

  question = QuestionBank::Question.where(:id => @question.id).first

  expect(question.content).to eq(@input[:content])

  expect(question.fill_answer).to eq(@input[:fill_answer])

  expect(question.analysis).to eq(@input[:analysis])
  expect(question.level).to eq(@input[:level])
  expect(question.enabled).to eq(@input[:enabled])
end


假如(/^给填空题录入一个位置的参考答案$/) do
  @input[:fill_answer] = ["答案一"]

  @fill_attrs[:fill_answer] = @input[:fill_answer]
end

那么(/^填空题录入失败$/) do
  expect(@question.new_record?).to eq(true)
  expect(@question.valid?).to eq(false)
  expect(QuestionBank::Question.fill.count).to eq(0)

  question = QuestionBank::Question.where(:id => @question.id).first
  expect(question.class).to eq(NilClass)
end

假如(/^给填空题录入一项待填空的内容，在内容中标记出零个位置需要填充。$/) do
  @input[:content] = "我是填空题的题设"

  @fill_attrs[:content] = @input[:content]
end
