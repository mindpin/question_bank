假如(/^题目录入员打算批量导入一系列题目$/) do
end

假如(/^按照批量导入题目标准格式示例文件编辑数据文件，编辑后的数据文件格式没有问题$/) do
  path = File.expand_path("../../../data/question_import_demo.csv",__FILE__)
  file = File.new(path)
  @import_question = QuestionBank::ImportQuestion.new(file)
end

假如(/^解析数据文件没有出错$/) do
  expect(@import_question.valid?).to eq(true)
end

那么(/^题目导入成功$/) do
  expect{
    @import_question.import
  }.to change{QuestionBank::Question.count}.by(7)
end
