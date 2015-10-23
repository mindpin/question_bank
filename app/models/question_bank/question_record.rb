module QuestionBank
  class QuestionRecord
    include Mongoid::Document
    include Mongoid::Timestamps

    field :question_id, type: String          # 题目的外键关联
    field :user_id, type: String              #做题用户的外键关联
    field :is_correct, type: Boolean          # 题目是否正确

    field :bool_answer, type: Boolean         # 判断题
    field :single_choice_answer, type: Array  # 单选题
    field :multi_choice_answer , type: Array  # 多选题
    field :essay_answer, type: String         # 论述题
    field :fill_answer, type: Array           # 填空题
    field :mapping_answer, type: Array        # 连线题

    validate :validates_answer_kind
    validate :validates_answer_format

    # 校验类型
    def validates_answer_kind
        @question_kind = QuestionBank::Question.where( self.question_id).kind
        self.record_answer_ary.each do |r|
            if r == @question_kind && r == nil
                errors.add(:r, "#{r}不能为空")
            end
        end

        self.record_answer_ary.each do |r|
            if r != @question_kind && r != nil
                errors.add(:r, "#{r}必须为空")
            end
        end
    end

    # 校验格式
    def validates_answer_format
        @question_kind = QuestionBank::Question.where( self.question_id).kind
        if @question_kind == bool_answer && ( bool_answer != true || bool_answer != false )
            errors.add(:bool_answer, "判断题答案格式不正确")
        end

        if @question_kind == single_choice_answer && single_choice_answer.count != 1
            errors.add(:single_choice_answer, "单选题答案格式不正确")
        end

        if @question_kind == multi_choice_answer && multi_choice_answer.count < 2
            errors.add(:multi_choice_answer, "多选题答案格式不正确")
        end

        if @question_kind == essay_answer && !essay_answer.is_a?(String)
            errors.add(:essay_answer, "论述题答案格式不正确")
        end

        if @question_kind == fill_answer && ( @question_kind.count != fill_answer.count )
            errors.add(:fill_answer, "填空题答案格式不正确")
        end

         if @question_kind == mapping_answer && ( @question_kind.count != mapping_answer.count )
            errors.add(:mapping_answer, "连线题答案格式不正确")
        end
    end

    def question_id=(question_id)
      @question_id = question_id
    end

    def record_answer_ary
        record_answer = [ bool_answer, single_choice_answer, multi_choice_answer, essay_answer, fill_answer, mapping_answer]
        return record_answer
    end
  end 
end