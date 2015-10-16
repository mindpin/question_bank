module QuestionBank
  class QuestionRecord
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :is_correct, type: Boolean
    field :bool_answer, type: Boolean
    field :choice_answer, type: Array
    field :essay_answer, type: String
    field :fill_answer, type: Array
    field :mapping_answer, type: Array

    belongs_to :question, class_name: 'QuestionBank::Question'
    belongs_to :user, class_name: 'QuestionBank::User'


  end
end