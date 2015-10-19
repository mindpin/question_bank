module QuestionBank
  class QuestionRecord
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :is_correct, type: Boolean
    field :bool_answer, type: Boolean  # 判断题
    field :choice_answer, type: Array  # 选择题(单选和多选)
    field :essay_answer, type: String  # 论述题
    field :fill_answer, type: Array    # 填空题
    field :mapping_answer, type: Array # 连线题

    belongs_to :question, class_name: 'QuestionBank::Question'
    belongs_to :user, class_name: 'User'

    validates_each :bool_answer, :choice_answer, :essay_answer, :fill_answer, :mapping_answer do |record, attr, value|
        record.errors.add attr, "attribute is wrong" 
    end



  end
end