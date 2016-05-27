module QuestionBank
  class QuestionRecord
    include Mongoid::Document
    include Mongoid::Timestamps
    include QuestionBank::TimeKindScope
    include QuestionBank::EnumerizeKind

    field :is_correct,     type: Boolean
    field :answer

    belongs_to :question, class_name: 'QuestionBank::Question'
    belongs_to :user,     class_name: QuestionBank.user_class
    belongs_to :test_paper_result,  class_name: 'QuestionBank::TestPaperResult'

    validates :question_id, presence: true
    validates :user_id,     presence: true

    scope :with_correct, -> (is_correct) {
      where(:is_correct => is_correct)
    }

    before_validation :_set_kind
    def _set_kind
      self.kind = self.question.kind if !self.question.blank?
    end

    after_validation :_set_correct
    def _set_correct
      return if self.errors[:answer].count != 0
      return if self.question.blank?

      case self.question.kind.to_sym
      when :single_choice
        _set_correct_of_single_choice
      when :multi_choice
        _set_correct_of_multi_choice
      when :bool
        _set_correct_of_bool
      when :fill
        _set_correct_of_fill
      when :essay
        _set_correct_of_essay
      when :mapping
        _set_correct_of_mapping
      end
    end

    # 检查考试时间是否超时
    validate :_check_test_paper_minutes
    def _check_test_paper_minutes
      return if self.test_paper_result.blank?

      test_paper = self.test_paper_result.test_paper
      mins       = test_paper.minutes
      return if mins.blank?
      expires_at = self.test_paper_result.created_at + mins.minutes
      if Time.now > expires_at
        errors.add(
          :answer,
          I18n.t("mongoid.errors.models.question_bank/question_record.attributes.answer.time_over"))
      end

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

    def _set_correct_of_mapping
      correct_answer = self.question.answer["mappings"].sort_by(&:hash)
      input_answer = self.answer.sort_by(&:hash)
      self.is_correct = (correct_answer == input_answer)
    end

    def _set_correct_of_single_choice
      correct_answer = self.question.answer["correct"]
      input_answer   = self.answer
      self.is_correct = (correct_answer == input_answer)
    end

    def _set_correct_of_multi_choice
      correct_answer = self.question.answer["corrects"].sort
      input_answer   = self.answer.sort
      self.is_correct = (correct_answer == input_answer)
    end

    def _set_correct_of_bool
      correct_answer = self.question.answer
      input_answer   = self.answer
      self.is_correct = (correct_answer == input_answer)
    end

    def _set_correct_of_fill
      correct_answer = self.question.answer
      input_answer   = self.answer
      self.is_correct = (correct_answer == input_answer)
    end

    def _set_correct_of_essay
      correct_answer = self.question.answer
      input_answer   = self.answer
      self.is_correct = (correct_answer == input_answer)
    end

    def _check_answer_format_of_single_choice
      return _add_answer_format_error if !self.answer.is_a?(String)

      ids = self.question.answer["choices"].map{|choice|choice["id"]}
      return _add_answer_format_error if !ids.include?(self.answer)
    end

    def _check_answer_format_of_multi_choice
      self.answer = [] if self.answer.nil?
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
