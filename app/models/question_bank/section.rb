module QuestionBank
  class Section
    include Mongoid::Document
    include Mongoid::Timestamps
    include QuestionBank::EnumerizeKind
    # 引用排序模块
    include QuestionBank::MovePosition

    # 每题分值
    field :score,     type: Integer
    # 最低难度系数(1 2 3 4 5 6 7 8 9 10)
    field :min_level, type: Integer
    # 最高难度系数(1 2 3 4 5 6 7 8 9 10)
    field :max_level, type: Integer

    validates :score,     presence: true
    validates :min_level, presence: true
    validates :max_level, presence: true

    belongs_to :test_paper, class_name: 'QuestionBank::TestPaper', inverse_of: :sections

    has_and_belongs_to_many :questions, class_name: 'QuestionBank::Question'

    def parent
      test_paper
    end

    def questions
      question_ids.map{|id|QuestionBank::Question.find id}
    end

    def question_ids_str
      question_ids.map(&:to_s).join(",")
    end

    def question_ids_str=(str)
      self.question_ids = str.split(",")
    end
  end
end
