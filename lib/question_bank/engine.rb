module QuestionBank
  class Engine < ::Rails::Engine
    isolate_namespace QuestionBank
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper
    end
  end
end