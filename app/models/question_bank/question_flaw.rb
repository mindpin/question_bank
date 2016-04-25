module QuestionBank
  class QuestionFlaw
    include Mongoid::Document
    include Mongoid::Timestamps
    include QuestionBank::TimeKindScope
    include QuestionBank::EnumerizeKind

    belongs_to :question, :class_name => 'QuestionBank::Question'
    belongs_to :user, :class_name => QuestionBank.user_class

    before_validation :set_kind
    def set_kind
      self.kind = self.question.kind
    end

    module UserMethods
      extend ActiveSupport::Concern
        def flaw_questions
          res = QuestionBank::QuestionFlaw.collection.find(:user_id => self.id).select(:question_id => 1).to_a
          question_ids = res.map{|hash| hash["question_id"]}
          return QuestionBank::Question.where(:id.in => question_ids)
        end

        def add_flaw_question(question)
          if !question.question_flaws.where(:user_id => self.id.to_s).exists?
            question.question_flaws.create(:user => self)
          end
        end

        def remove_flaw_question(question)
          question.question_flaws.where(:user_id => self.id.to_s).destroy_all
        end
    end
  end
end
