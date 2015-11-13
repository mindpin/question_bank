module QuestionBank
  class ApplicationController < ActionController::Base
    layout "question_bank/application"
    include QuestionBank::ApplicationHelper
    if defined? PlayAuth
      helper PlayAuth::SessionsHelper
      include PlayAuth::SessionsHelper
    end
  end
end