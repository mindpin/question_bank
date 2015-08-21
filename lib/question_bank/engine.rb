module QuestionBank
  class Engine < ::Rails::Engine
    isolate_namespace QuestionBank
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper

      Dir.glob(File.join(File.expand_path("../../../",__FILE__), "app/models/question_bank/concerns/**.rb")).each do |rb|
        require_dependency rb
      end

    end
  end
end
