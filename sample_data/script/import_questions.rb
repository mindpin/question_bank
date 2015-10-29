module QuestionBank
  class ImportQuestions
    def self.import
      json_atr = IO.read(File.expand_path("../../data/questions.json", __FILE__))
      question_hash = JSON.parse(json_atr)
      questions = question_hash['questions']
      questions.each do |question|
        item = QuestionBank::Question.new(question)
        item.save
        p item.valid?
        p item.errors
        p 'success'
      end
    end
    self.import
  end
end
