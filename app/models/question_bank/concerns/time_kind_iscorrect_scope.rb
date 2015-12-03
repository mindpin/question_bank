module QuestionBank
  module TimeKindIscorrectScope
    extend ActiveSupport::Concern
    included do
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

    scope :with_correct, -> (is_correct) {
      where(:is_correct => is_correct)
    }
  end
  end
end