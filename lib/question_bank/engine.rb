module QuestionBank
  class Engine < ::Rails::Engine
    isolate_namespace QuestionBank
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper
      User.class_eval do
        has_many :question_flaws, class_name:'QuestionBank::QuestionFlaw',:order => :created_at.desc
        has_many :question_records, class_name:'QuestionBank::QuestionRecord',:order => :created_at.desc
        include QuestionBank::QuestionFlaw::UserMethods
      end
    end
    config.i18n.default_locale = "zh-CN"
  end
end
