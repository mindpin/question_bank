module QuestionBank
  class QuestionFlaw
    include Mongoid::Document
    include Mongoid::Timestamps
    belongs_to :question, :class_name => 'QuestionBank::Question'
    belongs_to :user, :class_name => QuestionBank.user_class

    extend Enumerize
    enumerize :kind, in: Question::KINDS
    before_validation :set_kind
    def set_kind
        self.kind = self.question.kind
    end

    module UserMethods
      extend ActiveSupport::Concern
        def flaw_questions
          # question_array = []
          # self.question_flaws.map do |flaw|
          #   question_array.push(flaw.question)
          # end
          # TODO 另一种方式
          p self.question_flaws
          question_array = self.question_flaws.only(:question_id).as_json
          p question_array.class
          p question_array
          return QuestionBank::Question.where(:id.in => [])
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
