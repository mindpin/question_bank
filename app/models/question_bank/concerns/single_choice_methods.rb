p "reload SingleChoiceMethods"
module QuestionBank
  module SingleChoiceMethods
    extend ActiveSupport::Concern

    included do
      validate :check_choice_answer_of_single_choice

      scope :single_choice, -> { where(kind: "single_choice") }
    end

    def check_choice_answer_of_single_choice
      return true if !self.kind.single_choice?

      # 待选选项最少两个
      if self.choices.count < 2
        errors.add(:choice_answer, I18n.t("question_bank.question.single_choice_count"))
      end

      # 答案只能有一个
      if self.choice_answer_indexs.count != 1
        errors.add(:choice_answer, I18n.t("question_bank.question.single_choice_answer_indexs_count"))
      end

    end

    module ClassMethods
    end

  end
end
