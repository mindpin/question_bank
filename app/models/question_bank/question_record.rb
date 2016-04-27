module QuestionBank
  class QuestionRecord
    include Mongoid::Document
    include Mongoid::Timestamps
    include QuestionBank::TimeKindScope
    include QuestionBank::EnumerizeKind

    field :is_correct,     type: Boolean
    field :answer

    belongs_to :question
    belongs_to :user

    validates :question_id, presence: true
    validates :user_id,     presence: true

    scope :with_correct, -> (is_correct) {
      where(:is_correct => is_correct)
    }

    before_validation :_set_kind
    def set_kind
      self.kind = self.question.kind if !self.question.blank?
    end

    before_validation :_set_correct
    def _set_correct
    end

    validate :_check_answer_format

    def _check_answer_format
      return if self.question.blank?
      case self.question.kind.to_sym
      when :single_choice
        _check_answer_format_of_single_choice
      when :multi_choice
        _check_answer_format_of_multi_choice
      when :bool
        _check_answer_format_of_bool
      when :fill
        _check_answer_format_of_fill
      when :essay
        _check_answer_format_of_essay
      when :mapping
        _check_answer_format_of_mapping
      end
    end

    def _check_answer_format_of_single_choice
      return _add_answer_format_error if !self.answer.is_a?(String)

      ids = self.question.answer["choices"].map{|choice|choice["id"]}
      return _add_answer_format_error if !ids.include?(self.answer)
    end

    def _check_answer_format_of_multi_choice
      return _add_answer_format_error if !self.answer.is_a?(Array)

      ids = self.question.answer["choices"].map{|choice|choice["id"]}
      self.answer.each do |item|
        return _add_answer_format_error if !ids.include?(item)
      end
    end

    def _check_answer_format_of_bool
      self.answer = true if self.answer  == "true"
      self.answer = false if self.answer == "false"
      return _add_answer_format_error if !self.answer.is_a?(Boolean)
    end

    def _check_answer_format_of_fill
      return _add_answer_format_error if !self.answer.is_a?(Array)
      return _add_answer_format_error if self.answer.size != self.question.fill_count
      self.answer.each do |item|
        return _add_answer_format_error if !item.is_a?(String)
      end
    end

    def _check_answer_format_of_essay
      return _add_answer_format_error if !self.answer.is_a?(String)
    end

    def _check_answer_format_of_mapping
      return _add_answer_format_error if !self.answer.is_a?(Array)

      if self.answer.count != self.question.answer["mappings"].count
        return _add_answer_format_error
      end

      left_ids  = self.question.answer["left"].map{|item|item["id"]}
      right_ids = self.question.answer["right"].map{|item|item["id"]}
      self.answer.each do |item|
        return _add_answer_format_error if !item.is_a?(Hash)
        return _add_answer_format_error if item.keys.sort != ["left","right"].sort

        return _add_answer_format_error if !left_ids.include?(item["left"])
        return _add_answer_format_error if !right_ids.include?(item["right"])
      end

      answer_left_ids  = self.answer.map{|item|item["left"]}
      answer_right_ids = self.answer.map{|item|item["right"]}

      return _add_answer_format_error if answer_left_ids.uniq.count  != answer_left_ids.count
      return _add_answer_format_error if answer_right_ids.uniq.count != answer_right_ids.count
    end

    def _add_answer_format_error
      errors.add(
        :answer,
        I18n.t("mongoid.errors.models.question_bank/question_record.attributes.answer.format_error"))
    end

  end
end
