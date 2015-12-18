module QuestionBank
  class Question
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
    include QuestionBank::TimeKindScope

    # 题目类型 枚举: 单选题 多选题 判断题 填空题 论述题 连线题
    KINDS = [:single_choice, :multi_choice, :bool, :fill, :essay, :mapping]

    enumerize :kind, in: KINDS

    # 题目正文
    field :content, :type => String

    # 附件
    # TODO
    # has_and_belongs_to_many :file_entities, :class_name => "FilePartUpload::FileEntity"

    # 答案解析
    field :analysis, :type => String

    # 难度系数(1 2 3 4 5 6 7 8 9 10)
    field :level, :type => Integer

    # 是否启用
    field :enabled, :type => Boolean, :default => false

    validates :content, :presence => true
    validates :level, :presence => true
    has_many :question_flaws,class_name:'QuestionBank::QuestionFlaw'
    has_many :question_records ,class_name:'QuestionBank::QuestionRecord'

    def human_kind
      I18n.t("custom.model.question.human_kind.#{self.kind}")
    end

    def is_in_flaw_list_of?(user)
        user.question_flaws.where(:question_id => self.id.to_s).exists?
    end
  end
end
