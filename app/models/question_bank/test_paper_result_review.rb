module QuestionBank
  class TestPaperResultReview
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize

    field :comment, type: String
    enumerize :status, in: [:processing, :completed], default: :processing

    belongs_to :user
    belongs_to :test_paper_result, class_name: "QuestionBank::TestPaperResult"

    has_many :question_reviews, class_name: "QuestionBank::TestPaperResultQuestionReview"

    def complete!
      self.status = 'completed'
      self.save!
    end

    def save_question_review(question, score, comment)
      qrr = self.question_reviews.where(question_id: question.id).first
      if qrr.blank?
        qrr = self.question_reviews.create(
          question_id: question.id,
          score: score,
          comment: comment
        )
      else
        qrr.score = score
        qrr.comment = comment
        qrr.save
      end
    end

    def question_review_status(question, reviewer)
      qrr = self.question_reviews.where(question_id: question.id).first
      if qrr.blank?
        return {
          score: nil,
          comment: nil
        }
      else
        return {
          score: qrr.score,
          comment: qrr.comment
        }
      end
    end
  end
end
