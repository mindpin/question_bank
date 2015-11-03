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

    validate :validate_kind_and_format

    def validate_kind_and_format
        self.validates_answer_kind
        self.validates_answer_format
    end

    # 校验类型
    def validates_answer_kind
        question_kind = QuestionBank::Question.find(self.questions.id).kind
        if question_kind == "bool"
            if bool_answer.blank?
                errors.add(:bool_answer, "判断题不能为空")
            end

            if !essay_answer.blank?
                errors.add(:essay_answer, "论述题必须为空")
            end

            if !fill_answer.blank?
                errors.add(:fill_answer, "填空题必须为空")
            end

            if !mapping_answer.blank?
                errors.add(:mapping_answer, "连线题必须为空")
            end

            if !choice_answer.blank?
                errors.add(:choice_answer, "选择题必须为空")
            end
        end

        if question_kind == "essay"
            if essay_answer.blank?
                errors.add(:essay_answer, "论述题不能为空")
            end

            if !bool_answer.blank?
                errors.add(:bool_answer, "判断题必须为空")
            end

            if !fill_answer.blank?
                errors.add(:fill_answer, "填空题必须为空")
            end

            if !mapping_answer.blank?
                errors.add(:mapping_answer, "连线题必须为空")
            end

            if !choice_answer.blank?
                errors.add(:choice_answer, "选择题必须为空")
            end
        end

        if question_kind == "fill"
            if fill_answer.blank?
                errors.add(:fill_answer, "填空题不能为空")
            end

            if !essay_answer.blank?
                errors.add(:essay_answer, "论述题必须为空")
            end

            if !bool_answer.blank?
                errors.add(:bool_answer, "判断题必须为空")
            end

            if !mapping_answer.blank?
                errors.add(:mapping_answer, "连线题必须为空")
            end

            if !choice_answer.blank?
                errors.add(:choice_answer, "选择题必须为空")
            end 
        end

        if question_kind == "mapping"
            if mapping_answer.blank?
                errors.add(:mapping_answer, "连线题不能为空")
            end

            if !essay_answer.blank?
                errors.add(:essay_answer, "论述题必须为空")
            end

            if !bool_answer.blank?
                errors.add(:bool_answer, "判断题必须为空")
            end

            if !fill_answer.blank?
                errors.add(:fill_answer, "填空题必须为空")
            end

            if !choice_answer.blank?
                errors.add(:choice_answer, "选择题必须为空")
            end
        end

        if question_kind == "single_choice"
            if single_choice_answer.blank?
                errors.add(:single_choice_answer, "连线题不能为空")
            end

            if !mapping_answer.blank?
                errors.add(:mapping_answer, "连线题必须为空")
            end

            if !essay_answer.blank?
                errors.add(:essay_answer, "论述题必须为空")
            end

            if !bool_answer.blank?
                errors.add(:bool_answer, "判断题必须为空")
            end

            if !fill_answer.blank?
                errors.add(:fill_answer, "填空题必须为空")
            end
        end

        if question_kind == "multi_choice"
            if multi_choice_answer.blank?
                errors.add(:multi_choice_answer, "连线题不能为空")
            end

            if !mapping_answer.blank?
                errors.add(:mapping_answer, "连线题必须为空")
            end

            if !essay_answer.blank?
                errors.add(:essay_answer, "论述题必须为空")
            end

            if !bool_answer.blank?
                errors.add(:bool_answer, "判断题必须为空")
            end

            if !fill_answer.blank?
                errors.add(:fill_answer, "填空题必须为空")
            end
        end
    end

    # 校验格式
    def validates_answer_format
        question_kind = QuestionBank::Question.find( self.questions.id).kind
        if question_kind == "single_choice"
            if self.choice_answer.map { |item| item.is_a?(Array) && item.count == 2 && item[0].is_a?(String) && item[1].is_a?(Boolean) }.include?(false) || self.choice_answer_indexs.count != 1
                errors.add(:single_choice_answer, "单选题答案格式不正确")
            end
        end

        if question_kind == "multi_choice"
            # question_choice_answer = QuestionBank::Question.find(self.question.id).choice_answer
            if self.choice_answer.map { |item| item.count == 2 && item.is_a?(Array) && item[0].is_a?(String) && item[1].is_a?(Boolean) }.include?(false) || self.choice_answer_indexs.count < 2
                errors.add(:multi_choice_answer, "多选题答案格式不正确")
            end

            # 做题记录是记录做题者的做题情况的（我自己理解）
            # 在这里我只需要判定为多选时其答案数不能小于两个
            # 如果我判定做题者所填写的答案与答案数目不相符时，我认为是相当
            # 于告诉了做题者的答案（待确认...）
            # if choice_answer_indexs.count != question_choice_answer.count && choice_answer_indexs.count < 2 
            #     errors.add(:multi_choice_answer, "多选题的答案不符")
            # end
        end

        if question_kind == "fill"
            if !self.fill_answer.is_a?(Array) || (self.fill_count != self.fill_answer.count)
                errors.add(:fill_answer, "填空题答案格式不正确")
            end
        end

        if question_kind == "mapping"
            question_mapping_answer = QuestionBank::Question.find( self.questions.id ).mapping_answer
            if self.mapping_answer.map { |item| !item.is_a?(Array) || item.count != 2 || !item[0].is_a?(String) || !item[1].is_a?(String) } || self.mapping_answer.count != question_mapping_answer.count  
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
      self.content.scan(/_+/).size
    end
  end
end