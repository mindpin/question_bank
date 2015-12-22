module QuestionBank
  class TestPaperResult
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user, :class_name => QuestionBank.user_class
    belongs_to :test_paper, :class_name => "QuestionBank::TestPaper"
    has_and_belongs_to_many :question_records, class_name:'QuestionBank::QuestionRecord'
    accepts_nested_attributes_for :question_records, allow_destroy: true


    def to_create_hash
      hash = {}
      self.question_records.each do |qr|
        hash[qr.question_id.to_s] = {
          :is_correct     => qr.is_correct,
          :correct_answer => qr.correct_answer
        }
      end
      hash
    end
  end
end
