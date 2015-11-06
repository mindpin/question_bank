module QuestionBank
  class QuestionFlaw
    include Mongoid::Document
    include Mongoid::Timestamps
    belongs_to :question,:class_name=>QuestionBank::Question
    belongs_to :user,:class_name=>QuestionBank.user_class

    module UserMethods
      extend ActiveSupport::Concern
        def flaw_questions
          self.questionflaws
        end

        def add_flaw_question(id)
          # self.question_id = id
          # self.save
        end
    end
  end
end
