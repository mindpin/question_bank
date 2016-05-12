module QuestionBank
  module EnumerizeKind
    extend Enumerize
    extend ActiveSupport::Concern


    # 题目类型 枚举: 单选题 多选题 判断题 填空题 论述题 连线题
    KINDS = [:single_choice, :multi_choice, :bool, :fill, :essay, :mapping, :qanda]

    included do
      enumerize :kind, in: KINDS
      validates :kind, presence: true
    end
  end
end
