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

    belongs_to :question
    belongs_to :user

    validate :validates_answer_kind
    validate :validates_answer_format
    # validates :choice_answer, :fill_answer, :mapping_answer, array: { inclusion: { in: %w{ ruby rails } }}
    # 校验类型
    def validates_answer_kind
        question_kind = QuestionBank::Question.where(self.question).kind
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
        question_kind = QuestionBank::Question.where(self.question).kind
        if question_kind == "bool"
            if bool_answer != true || bool_answer != false
                errors.add(:bool_answer, "判断题答案格式不正确")
            end
        end

        if question_kind == "single_choice"
            if choice_answer_indexs.count != 1 && self.choice_answer.is_a?
                errors.add(:single_choice_answer, "单选题答案格式不正确")
            end
        end

        if question_kind == "multi_choice"
            if choice_answer_indexs.count < 2 && self.choice_answer.is_a?
                errors.add(:multi_choice_answer, "多选题答案格式不正确")
            end
        end

        if question_kind == "essay"
            if !essay_answer.is_a?(String)
                errors.add(:essay_answer, "论述题答案格式不正确")
            end
        end

        if question_kind == "fill"
            question_fill_answer = QuestionBank::Question.where(self.question).fill_answer
            if self.fill_answer.is_a? && (question_fill_answer.count != fill_answer.count)
                errors.add(:fill_answer, "填空题答案格式不正确")
            end
        end

        if question_kind == "mapping"
            question_mapping_answer = QuestionBank::Question.where( self.questions ).mapping_answer
            if (question_mapping_answer.count != mapping_answer.count) || (self.mapping_answer.map { |m| m.map { |ma| ma[0].blank? && ma[1].blank? }.uniq == true }.uniq == true )
                errors.add(:mapping_answer, "连线题答案格式不正确")
            end
        end
    end
  end 
end