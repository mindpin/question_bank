module QuestionBank
  class QuestionRecord
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize
    include Kaminari::MongoidExtension::Document
    include QuestionBank::ChoiceMethods
    include QuestionBank::SingleChoiceMethods
    include QuestionBank::MultiChoiceMethods
    include QuestionBank::BoolMethods
    include QuestionBank::EssayMethods
    include QuestionBank::FillMethods
    include QuestionBank::MappingMethods

    KINDS = [:single_choice, :multi_choice, :bool, :fill, :essay, :mapping]
    enumerize :kind, in: KINDS

    field :question_id, type: String   # 题目的外键关联
    field :user_id, type: String   #做题用户的外键关联
    field :is_correct, type: Boolean   # 题目是否正确

    belongs_to :questions, class_name: 'QuestionBank::Question' 
    belongs_to :user, class_name: 'User'

    validate :validates_type

    def validates_type
        @question = QuestionBank::Question.where(question_id: question_id)
        question_kind = @question.kind
        KINDS.each do |k|
            if k != question_kind
                k = nil
            end
        end
    end

  end 
end