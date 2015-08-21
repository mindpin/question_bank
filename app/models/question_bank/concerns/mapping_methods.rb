p "reload MappingMethods"
module QuestionBank
  module MappingMethods
    extend ActiveSupport::Concern

    included do
      ## 连线题
      # 连线题所有的左侧选项
      ## 创建题目时传入参数的顺序需要记录下来，便于在题目维护界面回显
      # [
      #   [ "选项1", "对应选项1" ]
      #   [ "选项2", "对应选项2" ]
      #   [ "选项3", "对应选项3" ]
      #   [ "选项4", "对应选项4" ]
      # ]
      #
      field :mapping_answer, :type => Array

      scope :mapping, -> { where(kind: "mapping") }
      validate :check_mapping_answer_of_mapping
    end

    def check_mapping_answer_of_mapping
      return true if !self.kind.mapping?

      if self.mapping_answer.count < 2
        errors.add(:mapping_answer, I18n.t("question_bank.question.mapping_answer.count"))
      end
    end

    module ClassMethods
    end

  end
end
