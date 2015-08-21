p "reload MultiChoiceMethods"
module QuestionBank
  module MultiChoiceMethods
    extend ActiveSupport::Concern

    included do
      validate :check_choice_answer_of_multi_choice

      scope :multi_choice, -> { where(kind: "multi_choice") }
    end

    def check_choice_answer_of_multi_choice
      return true if !self.kind.multi_choice?

      # 待选选项最少两个
      if self.choices.count < 2
        errors.add(:choice_answer, I18n.t("question_bank.question.multi_choice_count"))
      end

      # 答案最少两个
      if self.choice_answer_indexs.count < 2
        errors.add(:choice_answer, I18n.t("question_bank.question.multi_choice_answer_indexs_count"))
      end
    end

    module ClassMethods
    end

  end
end
