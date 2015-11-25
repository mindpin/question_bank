module QuestionBank
  class Engine < ::Rails::Engine
    isolate_namespace QuestionBank
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper
      User.class_eval do
        has_many :questionflaws, class_name:'QuestionBank::QuestionFlaw'
        has_many :question_records, class_name:'QuestionBank::QuestionRecord'
        include QuestionBank::QuestionFlaw::UserMethods
      end
    end
    config.i18n.default_locale = "zh-CN"
  end
end
