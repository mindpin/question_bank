module QuestionBank
  class TestPaperResult
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize

    enumerize :_status, in: [:RUNNING, :REVIEW_COMPLETED], default: :RUNNING

    belongs_to :user,       class_name: QuestionBank.user_class
    belongs_to :test_paper, class_name: "QuestionBank::TestPaper"

    has_many :question_records, class_name: 'QuestionBank::QuestionRecord'
    accepts_nested_attributes_for :question_records, allow_destroy: true

    def status
      return "REVIEW_COMPLETED" if self._status.REVIEW_COMPLETED?
      return "FINISHED" if Time.now >= (self.created_at + self.test_paper.minutes.minutes)
      return "RUNNING"
    end

    def review_complete!
      self.update_attributes("_status" => "REVIEW_COMPLETED")
    end

    def subjective_question_score(question)
      return 0 if [:single_choice, :multi_choice, :bool].include?(question.kind.to_sym)

      scores = self.completed_reviews.map do |review|
        qr = review.question_reviews.where(question_id: question.id).first
        qr.score
      end

      scores.sum.to_f / scores.length
    end

    def score_data
      # if self.status != 'review_completed'
      #   return {
      #     total_score: 0,
      #     sections:   []
      #   }
      # end

      qr_status = {}
      self.question_records.each do |qr|
        next if ![:single_choice, :multi_choice, :bool].include?(qr.kind.to_sym)
        qr_status[qr.question_id.to_s] = qr.is_correct
      end

      total_score  = 0
      sections_data = []
      self.test_paper.sections.each do |section|
        questions_data = []
        section_total_score  = 0
        section.questions.each do |question|
          case question.kind.to_sym
            when :single_choice, :multi_choice, :bool
              if qr_status[question.id.to_s]
                score = section.score
              else
                score = 0
              end
              total_score += score
              section_total_score += score
              questions_data.push({
                id:    question.id.to_s,
                score: score
              })
            when :essay, :file_upload
              score        = self.subjective_question_score(question)
              total_score += score
              section_total_score += score
              questions_data.push({
                id:    question.id.to_s,
                score: score
              })
          end
        end

        sections_data.push({
          id: section.id.to_s,
          section_total_score: section_total_score,
          per_question_max_score:  section.score,
          questions: questions_data
        })
      end

      {
        total_score: total_score,
        max_score:   self.test_paper.score,
        sections:    sections_data
      }
    end

    def question_answer_status(question)
      qr = self.question_records.where(user_id: user.id, question_id: question.id).first

      if qr.blank?
        return {
          answer: nil,
          is_correct: false,
          filled: false
        }
      end

      if qr.kind == "bool"
        return {
          answer: qr.answer,
          is_correct: qr.is_correct,
          filled: !qr.answer.nil?
        }
      end

      return {
        answer: qr.answer,
        is_correct: qr.is_correct,
        filled: qr.answer.present?
      }
    end

    def review_status(reviewer)
      review = QuestionBank::TestPaperResultReview.where(
        user_id: reviewer.id,
        test_paper_result_id: self.id
      ).first

      if review.blank?
        return {
          comment: nil,
          status: nil
        }
      end

      return {
        comment: review.comment,
        status: review.status
      }

    end

    def question_review_status(question, reviewer)
      review = QuestionBank::TestPaperResultReview.where(
        user_id: reviewer.id,
        test_paper_result_id: self.id
      ).first

      if review.blank?
        return {
          score: nil,
          comment: nil
        }
      end

      review.question_review_status(question, reviewer)
    end

    def has_completed_reviews?
      completed_reviews.count > 0
    end

    def completed_reviews
      QuestionBank::TestPaperResultReview.where(
        test_paper_result_id: self.id,
        status: "completed"
      )
    end

    def review(reviewer)
      review = QuestionBank::TestPaperResultReview.where(
        user_id: reviewer.id,
        test_paper_result_id: self.id
      ).first

      if review.blank?
        review = QuestionBank::TestPaperResultReview.create(
          user_id: reviewer.id,
          test_paper_result_id: self.id
        )
      end
      review
    end

  end
end
