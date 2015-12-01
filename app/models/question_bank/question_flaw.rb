module QuestionBank
  class QuestionFlaw
    include Mongoid::Document
    include Mongoid::Timestamps
    belongs_to :question,:class_name=>'QuestionBank::Question'
    belongs_to :user,:class_name=>QuestionBank.user_class


    module UserMethods
      extend ActiveSupport::Concern
        def flaw_questions
          self.question_flaws
        end

        def add_flaw_question(question)
          QuestionBank::QuestionFlaw.create(:user => self,:question => question)
        end

        def remove_flaw_question(question)
          question_flaws = QuestionBank::QuestionFlaw.where(:user => self,:question => question).first
          question_flaws.destroy
        end
    end

    module QuestionMethods
      def is_in_flaw_list_of?(user)
        user.question_flaws.where(:question_id => self.id.to_s).exists?
      end
    end
  end
end
