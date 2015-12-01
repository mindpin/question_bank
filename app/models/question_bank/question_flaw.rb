module QuestionBank
  class QuestionFlaw
    include Mongoid::Document
    include Mongoid::Timestamps
    belongs_to :question, :class_name => 'QuestionBank::Question'
    belongs_to :user, :class_name => QuestionBank.user_class


    module UserMethods
      extend ActiveSupport::Concern
        def flaw_questions
          # TODO 需要重新实现
          question_flaws
        end

        def add_flaw_question(question)
          return if question.question_flaws.where(:user_id => self.id.to_s).exists?

          question.question_flaws.create(:user => self)
        end

        def remove_flaw_question(question)
          question.question_flaws.where(:user_id => self.id.to_s).destroy_all
        end
    end

    module QuestionMethods
      def is_in_flaw_list_of?(user)
        user.question_flaws.where(:question_id => self.id.to_s).exists?
      end
    end
  end
end
