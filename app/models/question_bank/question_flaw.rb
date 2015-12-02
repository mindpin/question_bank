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
      where(:kind => kind)
    }

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
