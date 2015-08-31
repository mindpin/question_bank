p "reload ChoiceMethods"
module QuestionBank
  module ChoiceMethods
    extend ActiveSupport::Concern

    included do
      ## 单选题，多选题选项及答案
      ## 创建题目时传入参数的顺序需要记录下来，便于在题目维护界面回显
      # [
      #   [ "XXXXX", true  ]
      #   [ "XXXXX",  true  ]
      #   [ "XXXXX", false ]
      #   [ "XXXXX", false ]
      # ]
      #
      field :choice_answer, :type => Array
      before_validation :set_choice_answer_by_choices_and_choice_answer_indexs
      validate :check_choice_answer_of_choice
    end

    def set_choice_answer_by_choices_and_choice_answer_indexs
      res = self.choices.map{|choice|[choice,false]}
      self.choice_answer_indexs.each do |index|
        if !res[index].blank?
          res[index][1] = true
        end
      end
      self.choice_answer = res
    end

    def check_choice_answer_of_choice
      return true if self.kind.blank?
      return true if !self.kind.single_choice? && !self.kind.multi_choice?

      # 选项不能是空
      self.choices.each do |choice|
        if choice.blank?
          errors.add(:choice_answer_indexs, I18n.t("mongoid.errors.models.question_bank/question.attributes.choice_answer_indexs.choice_has_blank"))
          break
        end
      end

      # 选项必须是字符串
      self.choices.each do |choice|
        if !choice.is_a?(String)
          errors.add(:choice_answer_indexs, I18n.t("mongoid.errors.models.question_bank/question.attributes.choice_answer_indexs.choice_must_is_string"))
        end
      end

      # 答案 index +1 不能大于选项数量
      self.choice_answer_indexs.each do |index|
        if index + 1 > self.choices.count
          errors.add(:choice_answer_indexs, I18n.t("mongoid.errors.models.question_bank/question.attributes.choice_answer_indexs.index_out_of_bounds"))
        end
      end
    end

    def choices
      return @choices if !@choices.blank?

      return [] if self.choice_answer.blank?
      self.choice_answer.map {|item| item[0]}.flatten
    end

    def choices=(choices)
      @choices = choices
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

    module ClassMethods
    end

  end
end
