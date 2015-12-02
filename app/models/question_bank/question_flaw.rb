module QuestionBank
  class QuestionFlaw
    include Mongoid::Document
    include Mongoid::Timestamps
    belongs_to :question, :class_name => 'QuestionBank::Question'
    belongs_to :user, :class_name => QuestionBank.user_class

    scope :with_created_at, -> (start_time,end_time) {
      if (!start_time.nil? && !end_time.nil?) || (start_time.nil? && end_time.nil?)
        where(:created_at.gte => start_time, :created_at.lte => end_time)
      end
      if start_time.nil?
        where(:created_at.lte => end_time)
      end 
      if end_time.nil?
        where(:created_at.gte => start_time)
      end
    }

    scope :with_kind, -> (kind) {
      
    }

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
