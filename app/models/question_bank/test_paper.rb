module QuestionBank
  class TestPaper
    include Mongoid::Document
    include Mongoid::Timestamps

    # 试卷标题
    field :title,   type: String
    # 试卷总分
    field :score,   type: Integer
    # 考试时间
    field :minutes, type: Integer
    # 是否启用
    field :enabled, type: Boolean, default: false

    validates :title,   presence: true
    validates :score,   presence: true
    validates :minutes, presence: true

    scope :recent,  -> {order(id: :desc)}
    scope :enabled, -> {where(enabled: true)}

    has_many :test_paper_results, class_name: 'QuestionBank::TestPaperResult'

    has_many :sections,           class_name: 'QuestionBank::Section', inverse_of: :test_paper
    accepts_nested_attributes_for :sections, allow_destroy: true
  end
end
