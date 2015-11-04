module QuestionBank
  class QuestionRecord
    include Mongoid::Document
    include Mongoid::Timestamps

    field :is_correct, type: Boolean          # 题目是否正确

    field :bool_answer, type: Boolean         # 判断题
    field :choice_answer , type: Array        # 选择题
    field :essay_answer, type: String         # 论述题
    field :fill_answer, type: Array           # 填空题
    field :mapping_answer, type: Array        # 连线题

    belongs_to :questions
    belongs_to :user

    # validate :validates_answer_kind
    # validate :validates_answer_format
    validate :validate_kind_and_format

    def validate_kind_and_format
      self.validates_answer_kind
      self.validates_answer_format
    end

    # 校验类型
    def validates_answer_kind
      question_kind = QuestionBank::Question.find( self.questions.id )
      if question_kind == "bool"
        if self.bool_answer.blank?
          errors.add(:bool_answer, "判断题不能为空")
        end

        if !self.essay_answer.blank?
          errors.add(:essay_answer, "论述题必须为空")
        end

        if !self.fill_answer.blank?
          errors.add(:fill_answer, "填空题必须为空")
        end

        if !self.mapping_answer.blank?
          errors.add(:mapping_answer, "连线题必须为空")
        end

        if !self.choice_answer.blank?
          errors.add(:choice_answer, "选择题必须为空")
        end
      end

      if question_kind == "essay"
        if self.essay_answer.blank?
          errors.add(:essay_answer, "论述题不能为空")
        end

        if !self.bool_answer.blank?
          errors.add(:bool_answer, "判断题必须为空")
        end

        if !self.fill_answer.blank?
          errors.add(:fill_answer, "填空题必须为空")
        end

        if !self.mapping_answer.blank?
          errors.add(:mapping_answer, "连线题必须为空")
        end

        if !self.choice_answer.blank?
          errors.add(:choice_answer, "选择题必须为空")
        end
      end

      if question_kind == "fill"
        if self.fill_answer.blank?
          errors.add(:fill_answer, "填空题不能为空")
        end

        if !self.essay_answer.blank?
          errors.add(:essay_answer, "论述题必须为空")
        end

        if !self.bool_answer.blank?
          errors.add(:bool_answer, "判断题必须为空")
        end

        if !self.mapping_answer.blank?
          errors.add(:mapping_answer, "连线题必须为空")
        end

        if !self.choice_answer.blank?
          errors.add(:choice_answer, "选择题必须为空")
        end 
      end

      if question_kind == "mapping"
        if self.mapping_answer.blank?
          errors.add(:mapping_answer, "连线题不能为空")
        end

        if !self.essay_answer.blank?
          errors.add(:essay_answer, "论述题必须为空")
        end

        if !self.bool_answer.blank?
          errors.add(:bool_answer, "判断题必须为空")
        end

        if !self.fill_answer.blank?
          errors.add(:fill_answer, "填空题必须为空")
        end

        if !self.choice_answer.blank?
          errors.add(:choice_answer, "选择题必须为空")
        end
      end

      if question_kind == "single_choice"
        if self.single_choice_answer.blank?
          errors.add(:single_choice_answer, "单选题题不能为空")
        end

        if !self.mapping_answer.blank?
          errors.add(:mapping_answer, "连线题必须为空")
        end

        if !self.essay_answer.blank?
          errors.add(:essay_answer, "论述题必须为空")
        end

        if !self.bool_answer.blank?
          errors.add(:bool_answer, "判断题必须为空")
        end

        if !self.fill_answer.blank?
          errors.add(:fill_answer, "填空题必须为空")
        end
      end

      if question_kind == "multi_choice"
        if self.multi_choice_answer.blank?
          errors.add(:multi_choice_answer, "多选题不能为空")
        end

        if !self.mapping_answer.blank?
          errors.add(:mapping_answer, "连线题必须为空")
        end

        if !self.essay_answer.blank?
          errors.add(:essay_answer, "论述题必须为空")
        end

        if !self.bool_answer.blank?
          errors.add(:bool_answer, "判断题必须为空")
        end

        if !self.fill_answer.blank?
          errors.add(:fill_answer, "填空题必须为空")
        end
      end
    end

    # 校验格式
    def validates_answer_format
      question_kind = QuestionBank::Question.find( self.questions.id).kind
      if question_kind == "bool"
          if !self.bool_answer.is_a?(Boolean)
            errors.add(:bool_answer, "判断题格式不正确")
          end
      end
      if question_kind == "single_choice"
        if self.choice_answer.map { |item| item.is_a?(Array) && item.count == 2 && item[0].is_a?(String) && item[1].is_a?(Boolean) }.include?(false) || self.choice_answer_indexs.count != 1
          errors.add(:single_choice_answer, "单选题答案格式不正确")
        end
      end

      if question_kind == "multi_choice"
        if self.choice_answer.map { |item| item.is_a?(Array) && item.count == 2 && item[0].is_a?(String) && item[1].is_a?(Boolean) }.include?(false) || self.choice_answer_indexs.count < 2
          errors.add(:multi_choice_answer, "多选题答案格式不正确")
        end 
      end

      if question_kind == "essay"
        if !self.essay_answer.is_a?(String)
          errors.add(:essay_answer, "论述题答案格式不正确")
        end
      end

      if question_kind == "fill"
        if !self.fill_answer.is_a?(Array) || (self.fill_count != self.fill_answer.count)
          errors.add(:fill_answer, "填空题答案格式不正确")
        end
      end

      if question_kind == "mapping"
        question_mapping_answer = QuestionBank::Question.find( self.questions.id ).mapping_answer
        if self.mapping_answer.map { |item| item.is_a?(Array) && item.count == 2 && item[0].is_a?(String) && item[1].is_a?(String) }.include?(false) || self.mapping_answer.count != question_mapping_answer.count 
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

    def fill_count
      question_content = QuestionBank::Question.find( self.questions.id).content
      question_content.scan(/_+/).size
    end
  end
end