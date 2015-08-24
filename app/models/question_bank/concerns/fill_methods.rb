p "reload FillMethods"
module QuestionBank
  module FillMethods
    extend ActiveSupport::Concern

    included do
      ## 填空题
      # ["",""]
      field :fill_answer, :type => Array
      ##

      scope :fill, -> { where(kind: "fill") }
      validate :check_fill_answer_of_fill
    end

    def check_fill_answer_of_fill
      return true if !self.kind.fill?

      if self.fill_count == 0
        errors.add(:fill_answer, I18n.t("question_bank.question.fill_answer.fill_count"))
      end

      if self.fill_count != self.fill_answer.count
        errors.add(:fill_answer, I18n.t("question_bank.question.fill_answer.count"))
      end
    end

    # 填空题的填空位置
    def fill_count
      self.content.scan(" ___ ").size
    end

    module ClassMethods
    end

  end
end
