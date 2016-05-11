class ApplicationController < ActionController::Base
  if defined? PlayAuth
    helper PlayAuth::SessionsHelper
    include PlayAuth::SessionsHelper
  end

  if defined? QuestionBank::ApplicationHelper
    helper QuestionBank::ApplicationHelper
    include QuestionBank::ApplicationHelper
  end

  def authorization_user
    if current_user.blank?
      redirect_to auth.developers_users_path
    end
  end
end
