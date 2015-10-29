namespace :question_bank do
  desc '录入题型（从json文件里导入各种题型到数据库QuestionBank::Question）'
  task :create_data => [:environment] do
   require File.expand_path("../../../sample_data/script/import_questions.rb",__FILE__)
   QuestionBank::ImportQuestions.import
  end

  desc "清空题型数据（数据库QuestionBank::Question）"
  task :remove_data => [:environment] do
   require File.expand_path("../../../sample_data/script/delete_questions.rb",__FILE__)
   QuestionBank::DeleteQuestions.delete_all
  end
end
