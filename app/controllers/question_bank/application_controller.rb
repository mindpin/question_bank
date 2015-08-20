module QuestionBank
  class ApplicationController < ActionController::Base
    layout "question_bank/application"

    if defined? PlayAuth
      helper PlayAuth::SessionsHelper
    end
  end
end