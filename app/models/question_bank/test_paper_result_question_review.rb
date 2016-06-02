module QuestionBank
  class TestPaperResultQuestionReview
    include Mongoid::Document
    include Mongoid::Timestamps

    field :score,   type: Integer
    field :comment, type: String

    belongs_to :question,          class_name: "QuestionBank::Question"
    belongs_to :test_paper_result_review, class_name: "QuestionBank::TestPaperResultReview"

  end
end
