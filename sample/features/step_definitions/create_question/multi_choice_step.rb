假如(/^题目录入员打算把一道多选题录入到题库中$/) do
  @input = {}

  @multi_choice_attrs = {:kind => 'multi_choice'}
end

假如(/^给多选题录入的题设$/) do
  @input[:content] = "我是多选题的题设"

  @multi_choice_attrs[:content] = @input[:content]
end

假如(/^给多选题录入两项待选择的内容$/) do
  @input[:choices] = [
    "我是多选题待选项一",
    "我是多选题待选项二"
  ]

  @multi_choice_attrs[:choices] = @input[:choices]
end

假如(/^给多选题录入参考答案，答案包含两个选项$/) do
  @input[:choice_answer_indexs] = [0,1]

  @multi_choice_attrs[:choice_answer_indexs] = @input[:choice_answer_indexs]
end

假如(/^给多选题录入题目解析$/) do
  @input[:analysis] = "我是多选题题目解析"

  @multi_choice_attrs[:analysis] = @input[:analysis]
end

假如(/^给多选题录入难度系数$/) do
  @input[:level] = 1

  @multi_choice_attrs[:level] = @input[:level]
end

假如(/^给多选题录入发布状态$/) do
  @input[:enabled] = false

  @multi_choice_attrs[:enabled] = @input[:enabled]
end

假如(/^保存多选题的所有录入$/) do
  @question = QuestionBank::Question.create(@multi_choice_attrs)
end

那么(/^多选题录入成功$/) do
  expect(@question.new_record?).to eq(false)
  expect(@question.valid?).to eq(true)

  expect(QuestionBank::Question.multi_choice.count).to eq(1)

  question = QuestionBank::Question.where(:id => @question.id).first

  expect(question.content).to eq(@input[:content])

  expect(question.choices).to eq(@input[:choices])
  expect(question.choice_answer_indexs).to eq(@input[:choice_answer_indexs])

  expect(question.analysis).to eq(@input[:analysis])
  expect(question.level).to eq(@input[:level])
  expect(question.enabled).to eq(@input[:enabled])


  choice_answer = @input[:choices]
  choice_answer = choice_answer.map do |choice|
    [choice, false]
  end
  @input[:choice_answer_indexs].each do |index|
    choice_answer[index][1] = true
  end

  expect(question.choice_answer).to eq(choice_answer)
end



假如(/^给多选题录入一项待选择的内容$/) do
  @input[:choices] = [
    "我是多选题待选项一",
  ]

  @multi_choice_attrs[:choices] = @input[:choices]
end

假如(/^给多选题录入参考答案，答案包含一个选项$/) do
  @input[:choice_answer_indexs] = [0]

  @multi_choice_attrs[:choice_answer_indexs] = @input[:choice_answer_indexs]
end

那么(/^多选题录入失败$/) do
  expect(@question.new_record?).to eq(true)
  expect(@question.valid?).to eq(false)
  expect(QuestionBank::Question.multi_choice.count).to eq(0)

  question = QuestionBank::Question.where(:id => @question.id).first
  expect(question.class).to eq(NilClass)
end
