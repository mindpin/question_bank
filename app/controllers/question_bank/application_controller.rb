module QuestionBank
  class ApplicationController < ActionController::Base
    layout "question_bank/application"
    if defined? PlayAuth
      helper PlayAuth::SessionsHelper
      include PlayAuth::SessionsHelper
    end

    def authorization_user
      if current_user.blank?
        redirect_to auth.developers_users_path
      end
    end
    
  end
end
