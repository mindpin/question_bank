假如(/^按照批量导入题目标准格式示例文件编辑数据文件，编辑后的数据文件格式有问题$/) do
  path = File.expand_path("../../../data/question_import_demo_fail.csv",__FILE__)
  file = File.new(path)
  @import_question = QuestionBank::ImportQuestion.new(file)
end

假如(/^解析数据文件出现错误$/) do
    expect(@import_question.valid?).to eq(false)
    info = {
      "9 行 G 列"  => "没有填写单选题答案",
      "10 行 G 列" => "多选题答案最少有两个",
      "11 行 G 列" => "填空题答案数量少于填空数量",
      "12 行 G 列" => "连线题答案数量最少有两个"
    }
    expect(@import_question.error_info).to eq(info)
end

那么(/^题目导入失败，显示错误信息$/) do
  expect{
    @import_question.import
  }.to change{QuestionBank::Question.count}.by(0)
end
