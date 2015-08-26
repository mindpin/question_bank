p "reload BoolMethods"
module QuestionBank
  module BoolMethods
    extend ActiveSupport::Concern

    included do
      ## 判断题选项及答案
      # 判断题的结果是否是正确的
      field :bool_answer, :type => Boolean
      ##

      scope :bool, -> { where(kind: "bool") }

      validates :bool_answer, :presence => true
    end

    module ClassMethods
    end

  end
end
