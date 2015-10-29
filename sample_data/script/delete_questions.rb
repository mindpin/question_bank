module QuestionBank
  class DeleteQuestions
    def self.delete_all
    QuestionBank::Question.destroy_all
    end
    self.delete_all
  end
end