module QuestionBank
  class TestPaperResult
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user, :class_name => QuestionBank.user_class
    belongs_to :test_paper, :class_name => "QuestionBank::TestPaper"
    has_and_belongs_to_many :question_records, class_name:'QuestionBank::QuestionRecord'
    accepts_nested_attributes_for :question_records, allow_destroy: true
  end
end