module QuestionBank
  class QuestionRecord
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize

    field :is_correct, type: Boolean          # 题目是否正确

    field :bool_answer, type: Boolean         # 判断题
    field :choice_answer , type: Array        # 选择题
    field :essay_answer, type: String         # 论述题
    field :fill_answer, type: Array           # 填空题
    field :mapping_answer, type: Array        # 连线题

    enumerize :kind, in: Question::KINDS
    belongs_to :question
    belongs_to :user

    scope :with_created_at, -> (start_time,end_time) {
      if (!start_time.nil? && !end_time.nil?) || (start_time.nil? && end_time.nil?)
        return where(:created_at.gte => start_time, :created_at.lte => end_time)
      end
      if start_time.nil?
        return where(:created_at.lte => end_time)
      end 
      if end_time.nil?
        return where(:created_at.gte => start_time)
      end
    }

    scope :with_kind, -> (kind) {
      where(:kind => kind)
    }

    scope :with_correct, -> (is_correct) {
      where(:is_correct => is_correct)
    }

    def answer=(answer)
      @answer = answer
    end

    before_validation :process_custom_logic
    def process_custom_logic
      set_kind
      set_answer_field_value
      set_is_correct
    end

    def set_kind
      if !self.question.blank?
        self.kind = self.question.kind
      end
    end

    # 一些答案的格式转换
    def string_to_bool(str)
      return true if str == "true" || str == true
      return false if str == "false" || str == false
    end

    def answer_to_format(answer)
      case self.kind
        when "single_choice","multi_choice" then
          new_answer = answer.map do |key,value|
            value[1] = string_to_bool(value[1])
            [value[0],value[1]]
          end
        when "mapping"
          new_answer = answer.map do |a|
            a[1]
          end
        when 'fill','essay'
          new_answer = answer
        when 'bool'
          new_answer = string_to_bool(answer)
      end
      new_answer
    end

    # 保存答案
    def set_answer_field_value
      return true if self.question.blank?
      if self.kind == "single_choice" || self.kind == "multi_choice"
        format_answer = answer_to_format(@answer)
        self.choice_answer = format_answer
        return true
      end

      if Question::KINDS.include?(self.kind.to_sym)
        format_answer = answer_to_format(@answer)
        field = "#{self.kind}_answer"
        self.send("#{field}=", format_answer)
        return true
      end
    end

    def set_is_correct
      return true if self.question.blank?
      if self.kind == "single_choice" || self.kind == "multi_choice"
        self.is_correct = (self.question.choice_answer == self.choice_answer)
        return true
      end

      if Question::KINDS.include?(self.kind.to_sym)
        field = "#{self.kind}_answer"
        self.is_correct = (self.question.send(field) == self.send(field))
        return true
      end
    end
    # 取得正确答案的方法
    def right_answer
      if self.kind == "single_choice" || self.kind == "multi_choice"
        return self.question.choice_answer
      end

      if Question::KINDS.include?(self.kind.to_sym)
        return self.question.send("#{self.kind}_answer")
      end
    end

    validate :validate_kind_and_format
    def validate_kind_and_format
      self.validates_answer_kind
      self.validates_answer_format
    end

    # 校验类型
    def validates_answer_kind
      must_nil_fields = %w(choice_answer bool_answer fill_answer essay_answer mapping_answer)
      if self.kind == "single_choice" || self.kind == "multi_choice"
        has_value_field = "choice_answer"
        must_nil_fields.delete "choice_answer"
      elsif Question::KINDS.include?(self.kind.to_sym)
        has_value_field = "#{self.kind}_answer"
        must_nil_fields.delete "#{self.kind}_answer"
      end

      if self.send(has_value_field).nil?
        i18n_key = I18n.t("mongoid.errors.models.question_bank/question.attributes.#{has_value_field}.blank")
        errors.add(has_value_field, i18n_key)
      end

      must_nil_fields.each do |field|
        if !self.send(field).nil?
          i18n_key = I18n.t("mongoid.errors.models.question_bank/question.attributes.#{has_value_field}.must_nil")
          errors.add(field, i18n_key)
        end
      end
    end

    # 校验格式
    def validates_answer_format
      if self.kind == "single_choice"
        if self.choice_answer.map { |item| item.is_a?(Array) && item.count == 2 && item[0].is_a?(String) && item[1].is_a?(Boolean) }.include?(false) || self.choice_answer_indexs.count != 1
          errors.add(:single_choice_answer, "单选题答案格式不正确")
        end
      end

      if self.kind == "multi_choice"
        if self.choice_answer.map { |item| item.is_a?(Array) && item.count == 2 && item[0].is_a?(String) && item[1].is_a?(Boolean) }.include?(false) || self.choice_answer_indexs.count < 2
          errors.add(:multi_choice_answer, "多选题答案格式不正确")
        end
      end

      if self.kind == "fill"
        if self.fill_answer.map{|item| item.is_a?(String) }.include?(false)
          errors.add(:fill_answer, "填空题答案格式不正确")
        end
      end

      if self.kind == "mapping"
        if self.mapping_answer.map { |item| item.is_a?(Array) && item.count == 2 && item[0].is_a?(String) && item[1].is_a?(String) }.include?(false) && self.question.mapping_answer.count != self.mapping_answer.count
          errors.add(:mapping_answer, "连线题答案格式不正确")
        end
      end
    end

    def choice_answer_indexs
      return @choice_answer_indexs if !@choice_answer_indexs.blank?

      return [] if self.choice_answer.blank?

      indexs = []
      self.choice_answer.map {|item| item[1]}.flatten.each_with_index do |val, index|
        indexs << index if val
      end
      indexs
    end

    def choice_answer_indexs=(choice_answer_indexs)
      @choice_answer_indexs = choice_answer_indexs.map{|index|index.to_i}.uniq
    end

  end
end
