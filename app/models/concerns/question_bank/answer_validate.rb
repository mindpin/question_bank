module QuestionBank
  module AnswerValidate
    extend ActiveSupport::Concern

    included do
      validate :_check_answer_format
      before_validation :_set_answer_of_essay_and_file_upload
    end

    def _set_answer_of_essay_and_file_upload
      if [:fill, :essay].include?(self.kind.to_sym)
        if self.answer.blank?
          self.answer = "zhanwei"
        end
      end
    end

    def _check_answer_format
      case self.kind.to_sym
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
      _check_hash_key(self.answer, ["choices", "correct"])
      return if errors[:answer].count != 0

      _check_choices_format(self.answer["choices"])
      return if errors[:answer].count != 0

      return _add_answer_format_error if !self.answer["correct"].is_a?(String)

      ids = self.answer["choices"].map{|choice|choice["id"]}
      if !ids.include?(self.answer["correct"])
        return _add_answer_format_error
      end
    end

    def _check_answer_format_of_multi_choice
      _check_hash_key(self.answer, ["choices", "corrects"])
      return if errors[:answer].count != 0

      _check_choices_format(self.answer["choices"])
      return if errors[:answer].count != 0

      return _add_answer_format_error if !self.answer["corrects"].is_a?(Array)

      ids = self.answer["choices"].map{|choice|choice["id"]}
      self.answer["corrects"].each do |correct|
        return _add_answer_format_error if !correct.is_a?(String)

        if !ids.include?(correct)
          return _add_answer_format_error
        end
      end

    end

    def _check_answer_format_of_mapping
      _check_hash_key(self.answer, ["left", "right", "mappings"])
      return if errors[:answer].count != 0

      _check_choices_format(self.answer["left"])
      return if errors[:answer].count != 0

      _check_choices_format(self.answer["right"])
      return if errors[:answer].count != 0

      return _add_answer_format_error if !self.answer["mappings"].is_a?(Array)

      left_count = self.answer["left"].count
      right_count = self.answer["right"].count
      mappings_count = self.answer["mappings"].count
      if !(left_count == right_count && left_count == mappings_count)
        return _add_answer_format_error
      end

      left_ids = self.answer["left"].map{|item|item["id"]}
      right_ids = self.answer["right"].map{|item|item["id"]}
      self.answer["mappings"].each do |mapping|
        _check_hash_key(mapping, ["left", "right"])
        return if errors[:answer].count != 0

        if !left_ids.include?(mapping["left"])
          return _add_answer_format_error
        end

        if !right_ids.include?(mapping["right"])
          return _add_answer_format_error
        end
      end

      mapping_left_ids = self.answer["mappings"].map{|mapping| mapping["left"]}
      mapping_right_ids = self.answer["mappings"].map{|mapping| mapping["right"]}

      if mapping_left_ids.count != mapping_left_ids.uniq.count
        return _add_answer_format_error
      end

      if mapping_right_ids.count != mapping_right_ids.uniq.count
        return _add_answer_format_error
      end
    end

    def _check_answer_format_of_bool
      self.answer = true if self.answer  == "true"
      self.answer = false if self.answer == "false"
      return _add_answer_format_error if !self.answer.is_a?(Boolean)
    end

    def _check_answer_format_of_fill
      return _add_answer_format_error if !self.answer.is_a?(Array)
      return _add_answer_format_error if self.answer.size != fill_count
      self.answer.each do |item|
        return _add_answer_format_error if !item.is_a?(String)
      end
    end

    def _check_answer_format_of_essay
      return _add_answer_format_error if !self.answer.is_a?(String)
    end

    def _check_choices_format(choices)
      return _add_answer_format_error if !choices.is_a?(Array)

      choices.each do |choice_item|
        _check_choice_item_format(choice_item)
        return if errors[:answer].count != 0
      end

      ids = choices.map{|choice|choice["id"]}
      if ids.uniq.count != ids.count
        return _add_answer_format_error
      end
    end

    def _check_choice_item_format(choice_item)
      return _add_answer_format_error if !choice_item.is_a?(Hash)

      choice_item["id"] = randstr if choice_item["id"].blank?
      _check_hash_key(choice_item, ["id", "text"])
      return if errors[:answer].count != 0

      return _add_answer_format_error if !choice_item["id"].is_a?(String)
      return _add_answer_format_error if !choice_item["id"].is_a?(String)
    end

    def _check_hash_key(hash, keys)
      return _add_answer_format_error if !hash.is_a?(Hash)
      return _add_answer_format_error if hash.keys.sort != keys.sort
    end

    def _add_answer_format_error
      errors.add(
        :answer,
        I18n.t("mongoid.errors.models.question_bank/question.attributes.answer.format_error"))
    end
  end
end
