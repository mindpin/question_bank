module QuestionBank
  class TestPaper
    include Mongoid::Document
    include Mongoid::Timestamps

    # 试卷标题
    field :title, :type => String
    # 试卷总分
    field :score, :type => Integer
    # 考试时间
    field :minutes, :type => Integer

    # 涉及知识点KnowledgePoint, 具体名称待定

    # 是否启用
    field :enabled, :type => Boolean, :default => false

    has_many :sections, class_name: 'QuestionBank::Section', inverse_of: :test_paper

    validates :title, :presence => true
    validates :score, :presence => true
    validates :minutes, :presence => true

    accepts_nested_attributes_for :sections, allow_destroy: true

    scope :recent, -> {order(id: :desc)}
  end
end
