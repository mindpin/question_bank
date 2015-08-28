module QuestionBank
  class SectionQuestion
    include Mongoid::Document
    include Mongoid::Timestamps
    # 引用排序模块
    include QuestionBank::Concerns::MovePosition

    belongs_to :section, class_name: 'QuestionBank::Section'
    belongs_to :question, class_name: 'QuestionBank::Question'

    def parent
      section
    end
  end
end
