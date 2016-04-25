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
      return true if self.kind.blank?
      return true if !self.kind.fill?


      if self.fill_count == 0
        errors.add(:content, I18n.t("mongoid.errors.models.question_bank/question.attributes.content.fill_answer_zero_count"))
        return
      end

      if self.fill_answer.blank? || self.fill_count != self.fill_answer.count
        errors.add(:fill_answer, I18n.t("mongoid.errors.models.question_bank/question.attributes.fill_answer.not_eq_count"))
        return
      end

      # 答案不能是空
      if !self.fill_answer.blank?

        self.fill_answer.each do |str|
          if str.blank?
            errors.add(:fill_answer, I18n.t("mongoid.errors.models.question_bank/question.attributes.fill_answer.fill_answer_has_blank"))
            break
          end
        end

      end



    end

    # 填空题的填空位置
    def fill_count
      self.content.scan(/_+/).size
    end

    module ClassMethods
    end

  end
end
