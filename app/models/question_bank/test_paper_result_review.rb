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

    def total_score
      return 0 if self.status != 'completed'

      total_score = 0
      qr_status = {}
      self.test_paper_result.question_records.each do |qr|
        next if ![:single_choice, :multi_choice, :bool].include?(qr.kind.to_sym)
        qr_status[qr.question_id.to_s] = qr.is_correct
      end

      question_reviews_status = {}
      self.question_reviews.each do |review|
        question_reviews_status[review.question_id.to_s] = review.score
      end

      self.test_paper_result.test_paper.sections.each do |section|
        section.questions.each do |question|
          case question.kind.to_sym
            when :single_choice, :multi_choice, :bool
              total_score += section.score if qr_status[question.id.to_s]
            when :essay, :file_upload
              total_score += question_reviews_status[question.id.to_s]
          end
        end
      end

      total_score
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
